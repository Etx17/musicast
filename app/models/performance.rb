class Performance < ApplicationRecord
  belongs_to :inscription
  belongs_to :tour

  delegate :candidat, to: :inscription


  def airs
    Air.where(id: air_selection)
  end

  def airs_titles
    airs.map(&:title)
  end

  def minutes
    airs.sum(&:length_minutes)
  end

end
