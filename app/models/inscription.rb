class Inscription < ApplicationRecord
  has_many :performances
  has_one :candidate_program
  belongs_to :candidat
  belongs_to :category

  has_one :inscription_order, dependent: :destroy
  has_many :inscription_item_requirements, dependent: :destroy
  has_many :choice_imposed_work_airs, dependent: :destroy

  accepts_nested_attributes_for :inscription_item_requirements, allow_destroy: true
  accepts_nested_attributes_for :choice_imposed_work_airs

  # scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :by_category, -> (category_id) { where(category_id: category_id).includes(candidat: :user) }
  scope :by_candidat, ->(candidat_id) { where(candidat_id: candidat_id) }

  enum status: {
    draft: 0,
    in_review: 1,
    accepted: 2,
    rejected: 3
  }

  delegate :edition_competition, to: :category
  delegate :competition, to: :edition_competition
  delegate :organism, to: :competition


  # Scope of inscriptions by user role. if organiser, all the inscriptions (we'ill see it later)
  # if candidat, only the inscriptions of the candidat

  scope :by_user_role, ->(user) do
    if user.organisateur?
      by_category(user.organisateur.category.id)
    elsif user.candidat?
      by_candidat(user.candidat.id)
    end
  end

  def order_state
    inscription_order&.state || "Brouillon"
  end
end
