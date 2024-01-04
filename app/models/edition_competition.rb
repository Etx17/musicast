class EditionCompetition < ApplicationRecord
  has_many :categories, dependent: :destroy
  belongs_to :competition
  has_one_attached :photo, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :documents, as: :parent
  accepts_nested_attributes_for :documents

  def disciplines
    categories.map(&:discipline).uniq
  end

  def days_remaining
    (end_of_registration.to_date - Date.today).to_i
  end
end
