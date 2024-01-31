class Tour < ApplicationRecord
  has_many :performances, dependent: :destroy
  belongs_to :category
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tour_requirement, dependent: :destroy

  validate :new_day_start_time_before_max_end_of_day_time
  attr_accessor :creating_schedule


  accepts_nested_attributes_for :tour_requirement
  accepts_nested_attributes_for :address
  has_many :pauses, dependent: :destroy

  def candidates_performances_that_passed_selections
    performances.filter{|p| p.inscription.accepted?}
  end

  def move_qualified_candidates_to_next_tour
    self.next_tour
    return unless self.next_tour.present?

    performances.each_with_index do |performance, index|
      if performance.is_qualified
        Performance.transaction do
          next_tour_perf = Performance.find_or_create_by(tour: next_tour, inscription: performance.inscription)
          total_air_selection = performance.air_selection + next_tour.imposed_air_selection

          next_tour_perf.update(air_selection: total_air_selection, order: index)
        end
      end
    end
  end

  def next_tour
    category.tours.where(is_finished: false).order(:tour_number).first
  end

  def generate_initial_performance_order
    shuffled_performances = performances.shuffle
    shuffled_performances.each_with_index do |performance, index|
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
    Organisateur.joins(organisms: {competitions: { edition_competitions: { categories: { tours: :performances } } }})
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
