class Tour < ApplicationRecord
  has_many :performances, dependent: :destroy
  belongs_to :category
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tour_requirement, dependent: :destroy

  validate :new_day_start_time_before_max_end_of_day_time
  attr_accessor :creating_schedule

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
  has_many :pauses, dependent: :destroy

  def candidates_performances_that_passed_selections
    performances.filter{|p| p.inscription.accepted?}
  end

  def move_qualified_candidates_to_next_tour

    tour_next= self.next_tour
    return if tour_next == self || tour_next.nil?

    performances.each_with_index do |performance, index|
      if performance.is_qualified
        # Lanelle je lui ai pas crée de performance, et du coup ca l'a pas trouvée
          next_tour_perf = Performance.find_or_create_by(tour: tour_next, inscription: performance.inscription)
          total_air_selection = performance.air_selection + next_tour.imposed_air_selection

          next_tour_perf.update(air_selection: total_air_selection, order: index + 1)
      end
    end
    # Il devrait y avoir le même nombre de performances dans le tour suivant que de qualifiées dans le tour actuel.
    raise "Not the same number of performances in the next tour than in the current tour" if tour_next.performances.count != performances.select(&:is_qualified).count
  end

  def next_tour
    category.tours.where(is_finished: false).order(:tour_number).first
  end

  def generate_initial_performance_order
    # Separate performances with no airs
    performances_with_airs, performances_without_airs = performances.partition { |performance| performance.airs.any? }

    # Group performances by air names
    performances_by_air = performances_with_airs.group_by { |performance| performance.airs.map(&:title) }

    # Create an empty list to hold the final order of performances
    final_order = []

    # While there are still groups left
    while performances_by_air.values.flatten.any?
      # Randomly select a group that doesn't contain the same air as the last performance in the final order list
      possible_groups = performances_by_air.keys - [final_order.last&.airs&.map(&:title)]
      possible_groups = performances_by_air.keys if possible_groups.empty? # fallback to all groups if no possible group found
      selected_group = possible_groups.sample

      # Remove a performance from this group and add it to the final order list
      performance = performances_by_air[selected_group].shift
      final_order << performance

      # If the group is now empty, remove it
      performances_by_air.delete(selected_group) if performances_by_air[selected_group].empty?
    end

    # Add performances without airs to the end of the final order
    final_order.concat(performances_without_airs)

    # Update the order of each performance
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

  def assign_pianist_to_each_performance(pianists, max_consecutive_performances_per_pianist = 255)
    performances.where.not(order: nil).order(:order).each_with_index do |performance, index|
      next if performance.inscription.candidate_brings_pianist_accompagnateur == true
      group_number = (index / max_consecutive_performances_per_pianist.to_f).floor
      pianist = pianists[group_number % pianists.size]
      performance.update(pianist_accompagnateur: pianist)
    end
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


  private

  def new_day_start_time_before_max_end_of_day_time
    if new_day_start_time && new_day_start_time >= max_end_of_day_time
      errors.add(:new_day_start_time, "must be before max end of day time")
    end
  end

end
