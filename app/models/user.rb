class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :invitable

  after_create :create_associated_role

  TERMS_VERSION = 1

  has_one :organisateur
  has_one :partner
  has_one :jury
  has_one :candidat
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: 'Noticed::Notification'
  has_many :inscriptions_paiements

  has_many :inscription_orders
  has_many :documents

  enum :inscription_role, { candidate: 0, organiser: 1, jury: 2, partner: 3, admin: 4 }
  validates :inscription_role, presence: true
  validates :accepted_terms, acceptance: { accept: true }

  accepts_nested_attributes_for :jury


  def after_sign_in_path_for(_resource)
    if current_user.role == "admin"
      admin_dashboard_path
    elsif current_user.role == "organisateur"
      organisateur_dashboard_path
    elsif current_user.role == "candidate"
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

  def is_organisateur?
    inscription_role == "organisateur" || Organisateur.exists?(user: self)
  end

  def is_candidat?
    inscription_role == "candidate" || Candidat.exists?(user: self)
  end

  def is_jury?
    inscription_role == "jury" || Jury.exists?(user: self)
  end

  def is_partner?
    inscription_role == "partner" || Partner.exists?(user: self)
  end

  def organisateur
    Organisateur.find_by(user: self)
  end

  def organism
    Organism.find_by(organisateur: organisateur)
  end

  def candidat
    Candidat.find_by(user: self)
  end

  def organises_category?(category)
    category.competition.organism.organisateur == organisateur
  end

  def organises_edition_competition?(edition_competition)
    edition_competition.organism.organisateur == organisateur
  end

  def needs_to_accept_terms?
    self.terms_version < TERMS_VERSION
  end

  def first_name
    case inscription_role
    when "organiser"
      organisateur&.nom_organisme || "Mr. Organisateur"
    when "candidate"
      candidat&.first_name || "Mr. Candidat"
    when "jury"
      jury&.first_name || "Utilisateur (prénom à modifier)"
    when "partner"
      partner&.first_name || "Utilisateur (prénom à modifier)"
    when "admin"
      "Admin"
    end
  end

  def last_name
    case inscription_role
    when "organisateur"
      organisateur&.last_name || "Utilisateur (nom à modifier)"
    when "candidate"
      candidat&.last_name || "Utilisateur (nom à modifier)"
    when "jury"
      jury&.last_name || "Utilisateur (nom à modifier)"
    when "partner"
      partner&.last_name || "Utilisateur (nom à modifier)"
    end
  end

  def name_and_email
    "#{first_name} #{last_name} - #{email}"
  end
end
