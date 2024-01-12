class Performance < ApplicationRecord
  belongs_to :inscription
  belongs_to :tour

  delegate :candidat, to: :inscription
  # air_selection is Array of air ids, text type

  def airs_titles
    airs = Air.where(id: air_selection)
    airs.map(&:title)
  end
end
