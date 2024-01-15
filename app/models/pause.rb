class Pause < ApplicationRecord
  belongs_to :tour

  def duration
    ((end_time - start_time) / 60).to_i.minutes
  end
end
