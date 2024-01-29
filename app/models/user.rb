class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_create :create_associated_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :organiser
  has_one :partner
  has_one :jury
  has_one :candidate
  has_many :inscriptions_paiements

  has_many :inscription_orders
  has_many :documents

  enum inscription_role: { candidate: 0, organiser: 1 }
  validates :inscription_role, presence: true

  def after_sign_in_path_for(_resource)
    if current_user.role == "admin"
      admin_dashboard_path
    elsif current_user.role == "organisateur"
      organisateur_dashboard_path
    elsif current_user.role == "candidat"
      candidat_dashboard_path
    elsif current_user.role == "jury"
      jury_dashboard_path
    else
      root_path
    end
  end

  def create_associated_role
    Candidat.create(user: self) if inscription_role == "candidate"
    Organisateur.create(user: self) if inscription_role == "organiser"
  end

  def organisateur
    Organisateur.find_by(user: self)
  end

  def candidat
    Candidat.find_by(user: self)
  end

  def jury
    Jure.find_by(user: self)
  end
end
