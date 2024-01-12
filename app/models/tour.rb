class Tour < ApplicationRecord
  has_many :performances, dependent: :destroy
  belongs_to :category
  has_one :address, as: :addressable, dependent: :destroy
  has_one :tour_requirement, dependent: :destroy

  accepts_nested_attributes_for :tour_requirement
  accepts_nested_attributes_for :address

  def generate_initial_performance_order
    shuffled_performances = performances.shuffle
    shuffled_performances.each_with_index do |performance, index|
      performance.update(order: index)
    end
  end

  def update_performance_order(performance_id, new_order)
    performance = performances.find(performance_id)
    current_order = performance.order

    Performance.transaction do
      if new_order < current_order
        performances.where('order >= ? AND order < ?', new_order, current_order).update_all('order = order + 1')
      elsif new_order > current_order
        performances.where('order <= ? AND order > ?', new_order, current_order).update_all('order = order - 1')
      end

      performance.update(order: new_order)
    end
  end

  def generate_performance_schedule(start_time, max_end_of_day_time, new_day_start_time, lunch_start_time, lunch_duration, morning_pause_time = nil, afternoon_pause_time = nil, morning_pause_duration_minutes = 0, afternoon_pause_duration_minutes = 0)
    # Consider doing this in a background job...

    performances = Tour.performances.order(:order)
    current_start_time = start_time

    performances.each do |performance|
      # Check for morning pause
      current_start_time += morning_pause_duration_minutes if morning_pause_time && current_start_time.strftime("%H:%M").to_time == morning_pause_time

      # Check for lunch break
      current_start_time += lunch_duration if current_start_time.strftime("%H:%M").to_time == lunch_start_time

      # Check for afternoon pause
      current_start_time += afternoon_pause_duration_minutes if afternoon_pause_time && current_start_time.strftime("%H:%M").to_time == afternoon_pause_time

      # Assign performance time and check end of day limit
      next_performance_end_time = current_start_time + performance.duration.minutes
      if next_performance_end_time <= max_end_of_day_time
        performance.update(start_time: current_start_time)
        current_start_time = next_performance_end_time
      else
        # Move to the next day
        current_start_time = (current_start_time + 1.day).change(hour: new_day_start_time)
        redo unless current_start_time >= max_end_of_day_time # Prevent infinite loop
      end
    end
  end

end
