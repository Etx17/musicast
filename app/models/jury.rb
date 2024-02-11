class Jury < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :organism_juries
  has_many :organisms, through: :organism_juries
  has_many :categories_juries

  def name_and_email
    "#{first_name} #{last_name} - #{email}"
  end
end
