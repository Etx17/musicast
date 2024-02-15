class Inscription < ApplicationRecord
  has_many :inscription_item_requirements, dependent: :destroy
  has_many :performances, dependent: :destroy
  has_one :candidate_program
  belongs_to :candidat
  belongs_to :category
  has_many :notes, dependent: :destroy
  has_one :inscription_order, dependent: :destroy
  has_many :choice_imposed_work_airs, dependent: :destroy
  has_many :semi_imposed_work_airs, dependent: :destroy

  validates :terms_accepted, acceptance: { accept: true }
  accepts_nested_attributes_for :inscription_item_requirements, allow_destroy: true
  accepts_nested_attributes_for :choice_imposed_work_airs
  accepts_nested_attributes_for :semi_imposed_work_airs
  accepts_nested_attributes_for :notes


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


  scope :by_user_role, ->(user) do
    if user.organisateur?
      by_category(user.organisateur.category.id)
    elsif user.candidat?
      by_candidat(user.candidat.id)
    end
  end

  validates :candidat, uniqueness: { scope: :category, message: "Vous avez déjà une inscription pour cette catégorie" }


  def has_same_organisateur_as?(organisateur_id)
    Organisateur.joins(organisms: {competitions: { edition_competitions: { categories: :inscriptions }} })
                .where(inscriptions: { id: id })
                .where(id: organisateur_id)
                .exists?
  end

  def update_average_score
    transaction do
      lock!
      self.average_score = notes.average(:note_value) || 0
      save
    end
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
    # self.performances.map(&:air_selection).flatten.reject { |air_id| air_id.blank? }.map{ |air_id| Air.find(air_id) }
    air_ids = self.performances.pluck(:air_selection).flatten.reject(&:blank?)
    return [] if air_ids.empty?
    Air.where(id: air_ids)
  end

  def remaining_days_before_end_of_registration
    end_date = self.category.edition_competition.end_of_registration
    (end_date.to_date - Date.today).to_i
  end

  def is_payed?
    inscription_order.present? && inscription_order&.paid?
  end

  def has_complete_requirement_items?
    # TOFIX
    return false if inscription_item_requirements.any?{|i| i.has_submitted_content? == false }
    return false if inscription_item_requirements.any?{|i| i.verification_status == "checked_invalid" }
    true
  end

  def has_complete_airs?
    result = true
    if category.semi_imposed_works.any?
      result = category.semi_imposed_works.sum(:number) == semi_imposed_work_airs&.count
    end

    if category.choice_imposed_works.any?
      result = result && category.choice_imposed_works&.sum(:number_to_select) == choice_imposed_work_airs.count
    end
    result

  end

  def motivation_essay
    inscription_item_requirements.filter{|i| i.item_type == "motivation_essay"}.first
  end
end
