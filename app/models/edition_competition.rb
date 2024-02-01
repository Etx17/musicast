class EditionCompetition < ApplicationRecord
  has_many :categories, dependent: :destroy
  belongs_to :competition
  has_one_attached :photo, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :documents, as: :parent
  accepts_nested_attributes_for :documents
  delegate :organism_id, to: :competition
  delegate :organism, to: :competition

  enum status: { draft: 0, published: 1, archived: 2 }

  def disciplines
    categories.pluck(:name).uniq
  end

  def days_remaining
    (end_of_registration.to_date - Date.today).to_i
  end

  def category_details
    categories.select(:name, :min_age, :max_age).map do |category|
      {
        name: category.name,
        min_age: category.min_age,
        max_age: category.max_age
      }
    end
  end

  def organism
    competition.organism
  end

  def max_prize_amount
    categories.map(&:prizes).flatten.map(&:amount).max
  end

  def has_same_organisateur_as?(organisateur_id)
    Organisateur.joins(organisms: { competitions:  :edition_competitions })
                .where(edition_competitions: { id: id })
                .where(id: organisateur_id)
                .exists?
  end
end
