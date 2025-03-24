class Inscription < ApplicationRecord
  has_many :inscription_item_requirements, dependent: :destroy
  has_many :performances, dependent: :destroy
  has_one :candidate_program
  belongs_to :candidat
  belongs_to :category
  has_many :notes, dependent: :destroy
  has_one :inscription_order
  has_many :choice_imposed_work_airs, dependent: :destroy
  has_many :semi_imposed_work_airs, dependent: :destroy

  accepts_nested_attributes_for :inscription_item_requirements, allow_destroy: true
  accepts_nested_attributes_for :choice_imposed_work_airs, allow_destroy: true
  accepts_nested_attributes_for :semi_imposed_work_airs, allow_destroy: true
  accepts_nested_attributes_for :notes

  has_one_attached :payment_proof

    # Step 1: Program validations
    with_options on: :program do |program|
      validate :validate_choice_imposed_works
    end

    # Step 2: Item Requirements validations
    with_options on: :item_requirements do |items|
      items.validate :validate_required_documents
    end

    # Step 3: Preferences validations
    with_options on: :preferences do |prefs|
      prefs.validates :time_preference, presence: true
      prefs.validates :terms_accepted, acceptance: true
      prefs.validate :validate_pianist_details
    end
  attr_accessor :remove_payment_proof

  before_save :check_remove_payment_proof

  scope :by_category, -> (category_id) { where(category_id: category_id).includes(candidat: :user) }
  scope :by_candidat, ->(candidat_id) { where(candidat_id: candidat_id) }

  enum :status, {
    draft: 0,
    in_review: 1,
    request_changes: 2,
    accepted: 3,
    rejected: 4,
  }
  enum :time_preference, {
    no_preference: 0,
    morning: 1,
    afternoon: 2,
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
    # Collect all unique airs associated with this inscription
    airs = (self.choice_imposed_work_airs&.map(&:air) + self.semi_imposed_work_airs&.map(&:air)).uniq

    # Collect IDs of airs already selected in this inscription's performances
    selected_air_ids = self.performances.map(&:air_selection).flatten.reject(&:blank?)

    # Find all airs that have been selected in other inscriptions' performances
    # Exclude these airs unless they are selected in the current inscription's performances
    already_used_air_ids = Performance.where.not(inscription_id: self.id).map(&:air_selection).flatten.uniq.reject(&:blank?)
    airs_to_exclude = already_used_air_ids - selected_air_ids

    # Filter the airs to exclude the ones used in other inscriptions' performances
    airs.reject! { |air| airs_to_exclude.include?(air.id.to_s) }

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
    # Soit c'est payé, soit il y a une preuve de paiement # si c'est une preuve caduque, on peut toujours request changes avec un message
    (inscription_order.present? && inscription_order&.paid?) || payment_proof.attached?
  end

  def has_complete_requirement_items?
    return false if category.requirement_items.count != inscription_item_requirements.count
    return false if inscription_item_requirements.any?{|i| i.has_submitted_content? == false }
    return false if inscription_item_requirements.any?{|i| i.verification_status == "checked_invalid" }
    true
  end

  def is_ready_to_be_reviewed?
    valid?(:program) && valid?(:item_requirements) && valid?(:preferences)
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

  def self.find_or_create_without_validation(attributes)
    result = find_by(attributes)
    return result if result

    record = new(attributes)
    record.status = 'draft' if record.status.blank?
    record.save(validate: false)
    record
  end

  private

  def check_remove_payment_proof
    if remove_payment_proof == "1" && payment_proof.attached?
      payment_proof.purge
    end
  end

  def validate_choice_imposed_works
    choice_imposed_work_airs.group_by(&:air_id).each do |air_id, choice_imposed_work_airs|
      if choice_imposed_work_airs.count > 1
        errors.add(:base, :duplicate_air_id, message: "You can't select twice the same air")
      end
    end
  end

  def validate_required_documents
    # Check if documents are of the right format but i guess it's done in the view with JS no ?
  end

  def validate_pianist_details
    if candidate_brings_pianist_accompagnateur?
      if candidate_brings_pianist_accompagnateur_full_name.blank?
        errors.add(:candidate_brings_pianist_accompagnateur_full_name, :blank)
      end

      if candidate_brings_pianist_accompagnateur_email.blank?
        errors.add(:candidate_brings_pianist_accompagnateur_email, :blank)
      elsif !candidate_brings_pianist_accompagnateur_email.match?(URI::MailTo::EMAIL_REGEXP)
        errors.add(:candidate_brings_pianist_accompagnateur_email, :invalid)
      end
    end
  end
end
