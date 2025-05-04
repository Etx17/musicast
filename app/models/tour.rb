class Tour < ApplicationRecord
  has_many :performances, dependent: :destroy
  has_many :candidate_rehearsals, dependent: :destroy
  has_and_belongs_to_many :rooms

  belongs_to :category
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tour_requirement, dependent: :destroy

  validate :new_day_start_time_before_max_end_of_day_time
  attr_accessor :creating_schedule
  attr_accessor :rehearse_time_slot_per_candidate


  validates :title, :description, :start_date, :final_performance_submission_deadline, presence: true
  validates :title, uniqueness: { scope: :category_id, message: "should be unique per category" }
  validates :max_end_of_day_time, :new_day_start_time, presence: true, if: :creating_schedule
  validates :max_end_of_day_time, :comparison => { :greater_than => :new_day_start_time, message: "Doit finir après le début " }, if: :creating_schedule
  validates :max_end_of_day_time, :comparison => { :greater_than => :start_time, message: "Doit finir après le début " }, if: :creating_schedule
  validates :new_day_start_time, :comparison => { :less_than => :max_end_of_day_time, message: "Doit commencer avant la fin " }, if: :creating_schedule
  validates :title, length: { maximum: 50 }
  validates :description, length: { maximum: 500 }
  validates :final_performance_submission_deadline, comparison: { less_than: :start_date, message: "must be before the start date" }
  validates :tour_number, numericality: { only_integer: true }
  validates :start_date, :comparison => { greater_than_or_equal_to: Date.today, message: "Ne peux pas être dans le passé!" }
  validates :final_performance_submission_deadline, :comparison => { greater_than_or_equal_to: Date.today, message: "Ne peux pas être dans le passé!" }


  accepts_nested_attributes_for :tour_requirement
  accepts_nested_attributes_for :address
  has_many_attached :scores, dependent: :destroy
  has_many :pauses, dependent: :destroy

  enum :rehearsal_type, {
    solo_warmup: 0,
    pianist_warmup: 1,
    pianist_rehearsal: 2,
    orchestra_rehearsal: 3
  }

  def candidates_performances_that_passed_selections
    performances.filter{|p| p.inscription.accepted?}
  end

  def rehearse_time_slot_per_candidate
    return 30 unless self[:rehearse_time_slot_per_candidate]
    self[:rehearse_time_slot_per_candidate]
  end

  def move_qualified_candidates_to_next_tour

    tour_next= self.next_tour
    return if tour_next == self || tour_next.nil?

    performances.each_with_index do |performance, index|
      if performance.is_qualified
          next_tour_perf = Performance.find_or_create_by(tour: tour_next, inscription: performance.inscription)
          total_air_selection = performance.air_selection + next_tour.imposed_air_selection

          next_tour_perf.update(air_selection: total_air_selection, order: index + 1)
      end
    end
    raise "Not the same number of performances in the next tour than in the current tour" if tour_next.performances.count != performances.select(&:is_qualified).count
  end

  def next_tour
    category.tours.where("tour_number > ?", tour_number)
             .order(tour_number: :asc)
             .first
  end

  def generate_initial_performance_order
    performances_with_airs, performances_without_airs = performances.partition { |performance| performance.airs.any? }
    performances_by_air = performances_with_airs.group_by { |performance| performance.airs.map(&:title) }

    final_order = []

    while performances_by_air.values.flatten.any?
      possible_groups = performances_by_air.keys - [final_order.last&.airs&.map(&:title)]
      possible_groups = performances_by_air.keys if possible_groups.empty? # fallback to all groups if no possible group found
      selected_group = possible_groups.sample

      performance = performances_by_air[selected_group].shift
      final_order << performance
      performances_by_air.delete(selected_group) if performances_by_air[selected_group].empty?
    end

    final_order.concat(performances_without_airs)

    final_order.each_with_index do |performance, index|
      performance.update(order: index)
    end
  end

  def update_performance_order(performance_id, new_order)
    performance = performances.find(performance_id)
    current_order = performance.order
    new_order = new_order.to_i
    Performance.transaction do
      if new_order < current_order
        performances.where('"order" >= ? AND "order" < ?', new_order, current_order).update_all('"order" = "order" + 1')
      elsif new_order > current_order
        performances.where('"order" <= ? AND "order" > ?', new_order, current_order).update_all('"order" = "order" - 1')
      end

      performance.update(order: new_order)
    end
  end

  def assign_pianist_manually_to_performance(performance, pianist_accompagnateur_id)
    performance.update!(pianist_accompagnateur_id: pianist_accompagnateur_id)
  end

  def is_ready_for_planning_generation?
    final_performance_submission_deadline < Date.today
  end

  def generate_performance_schedule
    performances = self.performances.order(:order)
    current_start_time = start_time
    current_start_date = start_date

    raise "empty durations"if performances.any?{|p| p.air_selection.any?{|air| air.blank?}}

    performances.each do |performance|
      # Si la performance actuelle n'a pas renseignée sa durée, lui assigner le temps max du tour.
      next_performance_end_time = current_start_time + performance.minutes.minutes

      # Assign performance time and check end of day limit
      if next_performance_end_time.strftime("%H:%M:%S") <= max_end_of_day_time.strftime("%H:%M:%S")
        performance.update(start_time: current_start_time, start_date: current_start_date)
        current_start_time = next_performance_end_time
      else
        # Move to the next day
        current_start_time = new_day_start_time
        current_start_date += 1.day
        redo unless current_start_time.strftime("%H:%M").to_time >= max_end_of_day_time.strftime("%H:%M")
      end
    end
  end

  def days_of_performances
    days = performances.map(&:start_date).uniq || []
    days.reject(&:blank?).sort
  end

  def assign_pianist_to_each_performance(pianists, max_consecutive_performances_per_pianist = 255, min_consecutive_performances_per_pianist = 1)
    return if pianists.empty?

    # Get only performances that need an assigned pianist
    ordered_performances = performances.where.not(order: nil).order(:order)

    # Filter performances where the candidate does not bring their own pianist
    performances_needing_pianist = ordered_performances.select do |performance|
      !performance.inscription.candidate_brings_pianist_accompagnateur
    end

    return if performances_needing_pianist.empty?

    # Ensure minimum doesn't exceed maximum and have valid values
    min_consecutive = [min_consecutive_performances_per_pianist.to_i, 1].max
    max_consecutive = [max_consecutive_performances_per_pianist.to_i, min_consecutive].max

    # Calculate ideal distribution
    total_performances = performances_needing_pianist.count
    ideal_per_pianist = total_performances.to_f / pianists.size

    # Initialize tracking variables
    pianist_total_counts = Hash.new(0)
    pianist_indexes = (0...pianists.size).to_a
    current_pianist_index = pianist_indexes.first
    consecutive_count = 0

    # Process performances in order
    performances_needing_pianist.each do |performance|
      # Decision logic for selecting pianist
      if consecutive_count >= max_consecutive
        # Must change pianist because we hit maximum consecutive limit
        consecutive_count = 0
        # Find pianist with lowest count
        current_pianist_index = pianist_indexes.min_by { |idx| pianist_total_counts[idx] }
      elsif consecutive_count >= min_consecutive
        # Can optionally change pianist for balancing
        min_count = pianist_total_counts.values.min
        max_count = pianist_total_counts.values.max

        # If current pianist has significantly more performances than others, switch
        if pianist_total_counts[current_pianist_index] > min_count + 1
          consecutive_count = 0
          current_pianist_index = pianist_indexes.min_by { |idx| pianist_total_counts[idx] }
        end
      end

      # Assign pianist to performance
      pianist = pianists[current_pianist_index]
      performance.update(pianist_accompagnateur: pianist)

      # Update counts
      pianist_total_counts[current_pianist_index] += 1
      consecutive_count += 1
    end

    # Log final distribution for debugging
    Rails.logger.info "Pianist assignment distribution: #{pianist_total_counts.inspect}"
    # Calculate variance to measure balance
    counts = pianist_total_counts.values
    avg = counts.sum.to_f / counts.size
    variance = counts.map { |c| (c - avg)**2 }.sum / counts.size
    Rails.logger.info "Pianist assignment variance: #{variance} (lower is better balanced)"
  end

  def has_planning?
    performances.any?{|p| p.start_time.present?}
  end

  def remaining_days
    (final_performance_submission_deadline.to_date - Date.today).to_i
  end

  def has_same_organisateur_as?(organisateur_id)
    Organisateur.joins(organisms: {competitions: { edition_competitions: { categories: :tours } }})
      .where(tours: { id: id })
      .where(id: organisateur_id)
      .exists?
  end

  def previous_tour
    category.tours.where("tour_number < ?", tour_number)
             .order(tour_number: :desc)
             .first
  end

  private

  def new_day_start_time_before_max_end_of_day_time
    if new_day_start_time && new_day_start_time >= max_end_of_day_time
      errors.add(:new_day_start_time, "must be before max end of day time")
    end
  end

end
