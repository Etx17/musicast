class Jury < ApplicationRecord
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :organism_juries
  has_many :organisms, through: :organism_juries
  has_many :categories_juries

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true, on: :update
  validates :last_name, presence: true, on: :update

  has_one_attached :avatar
  def name_and_email
    # Utiliser les first°name et last_name du user associé si jamais ils sont pas la
    if first_name.nil? || last_name.nil?
      return user.name_and_email
    end
    "#{first_name} #{last_name} - #{email}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
