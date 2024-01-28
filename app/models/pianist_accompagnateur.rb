class PianistAccompagnateur < ApplicationRecord
  has_many :performances
  belongs_to :organism

  def is_assigned_to_future_performance?
    performances.where('start_date > ?', Date.today).any?
  end
end
