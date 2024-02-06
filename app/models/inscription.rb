class Inscription < ApplicationRecord
  has_many :performances, dependent: :destroy
  has_one :candidate_program
  belongs_to :candidat
  belongs_to :category

  has_one :inscription_order, dependent: :destroy
  has_many :inscription_item_requirements, dependent: :destroy
  has_many :choice_imposed_work_airs, dependent: :destroy
  has_many :semi_imposed_work_airs, dependent: :destroy


  accepts_nested_attributes_for :inscription_item_requirements, allow_destroy: true
  accepts_nested_attributes_for :choice_imposed_work_airs
  accepts_nested_attributes_for :semi_imposed_work_airs

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


  def has_same_organisateur_as?(organisateur_id)
    Organisateur.joins(organisms: {competitions: { edition_competitions: { categories: :inscriptions }} })
                .where(inscriptions: { id: id })
                .where(id: organisateur_id)
                .exists?
  end


  def order_state
    inscription_order&.state || "Brouillon"
  end

  def associated_airs
    airs = []
    airs += self.choice_imposed_work_airs&.map(&:air)
    airs += self.semi_imposed_work_airs&.map(&:air)
    airs.uniq!
    # Exclude airs that have already been used in other performances
    # But for the current tour, i need to still see the ones that are selected
    self.performances.map(&:air_selection).flatten.reject { |air_id| air_id.blank? }.map{ |air_id| Air.find(air_id) }
    airs

    airs
  end

  def used_airs
    self.performances.map(&:air_selection).flatten.reject { |air_id| air_id.blank? }.map{ |air_id| Air.find(air_id) }
  end

  def remaining_days_before_end_of_registration
    end_date = self.category.edition_competition.end_of_registration
    (end_date.to_date - Date.today).to_i
  end

  def is_payed?
    inscription_order.present? && inscription_order&.paid?
  end

  def has_complete_requirement_items?
    return false if inscription_item_requirements.any?{|i| i.has_submitted_content? == false }
    true
  end

  def has_complete_airs?
    category.semi_imposed_works.any? && category.semi_imposed_works.sum(:number) == semi_imposed_work_airs&.count && category.choice_imposed_works.any? && category.choice_imposed_works&.sum(:number_to_select) == choice_imposed_work_airs.count
  end
end
