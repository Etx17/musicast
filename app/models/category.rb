class Category < ApplicationRecord
  has_many :tours
  has_many :requirement_items
  has_many :inscriptions
  has_one :programme_requirement
  belongs_to :edition_competition
  has_many :documents, as: :parent, dependent: :destroy

  has_many :imposed_works, dependent: :destroy
  has_many :semi_imposed_works, dependent: :destroy
  has_many :free_choices, dependent: :destroy
  has_many :choice_imposed_works, dependent: :destroy

end
