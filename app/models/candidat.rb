class Candidat < ApplicationRecord
  belongs_to :user
  has_many :inscriptions, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy

  has_one_attached :portrait
  has_one_attached :banner

  accepts_nested_attributes_for :experiences
  accepts_nested_attributes_for :educations
  
end
