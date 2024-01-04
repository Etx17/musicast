class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :edition_competition, dependent: :destroy
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

end
