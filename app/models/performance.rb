class Performance < ApplicationRecord
  belongs_to :inscription
  belongs_to :tour

  has_one :tour_requirement, through: :tour

  delegate :candidat, to: :inscription


  enum status: {
    draft: 0,
    in_review: 1,
    accepted: 2,
    rejected: 3
  }

  def airs
    airs = Air.where(id: air_selection)
    
    airs += tour.imposed_air_selection if tour.imposed_air_selection.present?
    airs
  end

  def airs_titles
    airs.map(&:title)
  end

  def minutes
    airs.sum(&:length_minutes)
  end

  private


end
