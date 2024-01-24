class Candidat < ApplicationRecord
  belongs_to :user
  has_many :inscriptions, dependent: :destroy

  has_one_attached :portrait
  has_one_attached :banner
  
end
