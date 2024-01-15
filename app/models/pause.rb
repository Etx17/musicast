class Pause < ApplicationRecord
  belongs_to :tour

  def duration
    start_time_in_minutes = (start_time.hour * 60) + start_time.min
    end_time_in_minutes = (end_time.hour * 60) + end_time.min
    duration_in_minutes = end_time_in_minutes - start_time_in_minutes
    duration_in_minutes.minutes
  end
end
