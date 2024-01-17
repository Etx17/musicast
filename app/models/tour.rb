class Tour < ApplicationRecord
  has_many :performances, dependent: :destroy
  belongs_to :category
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tour_requirement, dependent: :destroy

  validate :new_day_start_time_before_max_end_of_day_time


  accepts_nested_attributes_for :tour_requirement
  accepts_nested_attributes_for :address
  has_many :pauses, dependent: :destroy

  def move_qualified_candidates_to_next_tour
    next_tour = determine_next_tour
    return unless next_tour.present?

    performances.each_with_index do |performance, index|
      if performance.is_qualified
        Performance.transaction do
          Performance.create(
            inscription: performance.inscription,
            tour: next_tour,
            order: index,
            # air selection: airs_imposed_ids_for_tour
          )
        end
      end
    end
  end

  def determine_next_tour
    category.tours.find_by(is_finished: false)
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

  def generate_performance_schedule
    performances = self.performances.order(:order)
    current_start_time = start_time
    current_start_date = start_date

    performances.each do |performance|
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
    performances.map(&:start_date).uniq || []
  end

  def has_planning?
    performances.any?{|p| p.start_time.present?}
  end

  private

  def new_day_start_time_before_max_end_of_day_time
    if new_day_start_time >= max_end_of_day_time
      errors.add(:new_day_start_time, "must be before max end of day time")
    end
  end

end
