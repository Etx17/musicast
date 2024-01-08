class Category < ApplicationRecord
  extend FriendlyId
  belongs_to :edition_competition, class_name: 'EditionCompetition', dependent: :destroy
  friendly_id :name, use: :slugged
  monetize :price_cents

  has_many :tours, dependent: :destroy
  has_many :requirement_items, dependent: :destroy
  has_many :inscriptions, dependent: :destroy
  has_one :programme_requirement, dependent: :destroy
  has_many :documents, as: :parent, dependent: :destroy

  has_one :imposed_work, dependent: :destroy
  has_many :semi_imposed_works, dependent: :destroy
  has_many :free_choices, dependent: :destroy
  has_many :choice_imposed_works, dependent: :destroy

  has_one_attached :photo

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
end
