class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :invitable

  after_create :create_associated_role

  TERMS_VERSION = 1

  has_one :organiser
  has_one :partner
  has_one :jury
  has_one :candidat
  has_many :inscriptions_paiements

  has_many :inscription_orders
  has_many :documents

  enum inscription_role: { candidate: 0, organiser: 1, jury: 2, partner: 3 }
  validates :inscription_role, presence: true
  validates :accepted_terms, acceptance: { accept: true }


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
    return unless inscription_role.present?
    if inscription_role == "candidate"
      candidate = Candidat.new(user: self)
      candidate.save(validate: false)
    elsif inscription_role == "organiser"
      organiser = Organisateur.new(user: self)
      organiser.save(validate: false)
    end
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

  def needs_to_accept_terms?
    self.terms_version < TERMS_VERSION
  end
end
