class Performance < ApplicationRecord
  belongs_to :inscription
  belongs_to :tour

  has_one :tour_requirement, through: :tour

  delegate :candidat, to: :inscription

  before_update :remove_empty_strings_from_air_selection

  enum status: {
    draft: 0,
    in_review: 1,
    accepted: 2,
    rejected: 3
  }

  def airs
    Air.where(id: air_selection)
  end

  def airs_titles
    airs.map(&:title)
  end

  def minutes
    airs.sum(&:length_minutes)
  end

  private

  def remove_empty_strings_from_air_selection
    self.air_selection = self.air_selection.reject(&:empty?)
  end

end
