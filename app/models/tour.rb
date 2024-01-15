class Tour < ApplicationRecord
  has_many :performances, dependent: :destroy
  belongs_to :category
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tour_requirement, dependent: :destroy

  accepts_nested_attributes_for :tour_requirement
  accepts_nested_attributes_for :address
  has_many :pauses, dependent: :destroy

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

end
