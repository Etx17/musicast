class Performance < ApplicationRecord
  belongs_to :inscription
  belongs_to :tour

  delegate :candidat, to: :inscription
  # air_selection is Array of air ids, text type
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
