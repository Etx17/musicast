class Category < ApplicationRecord
  extend FriendlyId
  belongs_to :edition_competition, class_name: 'EditionCompetition'
  friendly_id :name, use: :slugged
  monetize :price_cents

  has_many :tours, dependent: :destroy
  has_many :inscriptions, dependent: :destroy
  has_many :requirement_items, dependent: :destroy
  has_one :programme_requirement, dependent: :destroy
  has_many :documents, as: :parent, dependent: :destroy

  has_one :imposed_work, dependent: :destroy
  has_many :free_choices, dependent: :destroy
  has_many :semi_imposed_works, dependent: :destroy
  has_many :choice_imposed_works, dependent: :destroy
  has_many :prizes, dependent: :destroy

  has_one_attached :photo
  before_save :should_generate_new_friendly_id?, if: :name_changed?
  delegate :competition, to: :edition_competition

  enum status: {
    draft: 0,
    published: 1,
    archived: 2
  }

  # Dangereux, attention a la suppression des catégories et a l'ajout
  enum discipline: {
    alto: 1,
    ancient_instruments_and_baroque_music: 2,
    bassoon: 3,
    cello: 4,
    chamber_music: 5,
    choirs_and_choral_singing: 6,
    clarinet: 7,
    composition_and_musical_writing: 8,
    double_bass: 9,
    flute: 10,
    guitar: 11,
    harp: 12,
    horn: 13,
    lyrical_singing: 14,
    oboe: 15,
    orchestration_and_orchestra_conducting: 16,
    percussion: 17,
    piano: 18,
    trombone: 19,
    trumpet: 20,
    tuba: 21,
    violin: 22
  }

  # Validations
  validates :max_age, comparison: { greater_than_or_equal_to: :min_age }
  validates :name, :discipline, :min_age, :max_age, :description, :price_cents, presence: true

  validates :name, length: {minimum: 3, maximum: 50}
  validates :description, length: { maximum: 1000 }

  def should_generate_new_friendly_id?
    self.slug = name.parameterize if name_changed?
  end

  def is_accompagnated_by_pianist?
    discipline == 'lyrical_singing'
  end

  def has_same_organisateur_as?(organisateur_id)
    Organisateur.joins(organisms: { competitions: { edition_competitions: :categories } })
                .where(categories: { id: id })
                .where(id: organisateur_id)
                .exists?
  end

  def has_a_program?
    imposed_work.present? || choice_imposed_works.present? || semi_imposed_works.present?
  end

  def has_a_tour?
    tours.present? && tours.count > 0
  end

  def has_a_requirement_item?
    requirement_items.present? && requirement_items.count > 0
  end

  def has_a_prize?
    prizes.present? && prizes.count > 0
  end

  def ready_to_publish?
    has_a_program? && has_a_tour? && has_a_requirement_item? && has_a_prize?
  end

  def prize_pool_total_amount
    prizes&.sum(&:amount)
  end

  def biggest_prize_amount
    prizes&.maximum(:amount)
  end

end
