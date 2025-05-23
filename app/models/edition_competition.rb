class EditionCompetition < ApplicationRecord
  has_many :categories, dependent: :destroy
  belongs_to :competition
  has_one_attached :photo, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, allow_destroy: true
  has_many :documents, as: :parent
  accepts_nested_attributes_for :documents
  delegate :organism_id, to: :competition
  delegate :organism, to: :competition
  has_one_attached :rule_document, dependent: :destroy
  has_one_attached :rule_document_english, dependent: :destroy

  enum :status, { draft: 0, published: 1, archived: 2 }

  # Validations
  validates :annee, presence: true
  # validates :annee, comparison: { greater_than_or_equal_to: Date.today.year }
  validates :end_of_registration, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  # validates :start_date, comparison: { greater_than_or_equal_to: Date.today }
  # validates :end_date, comparison: { greater_than_or_equal_to: :start_date }
  validates :end_of_registration, comparison: { less_than_or_equal_to: :start_date }

  validate :correct_mime_type_of_rule_document
  validate :correct_mime_type_of_rule_document_english
  def self.published_and_upcoming
    EditionCompetition.includes(:categories, :address)
                      .where('end_of_registration > ?', Time.current)
                      .where(status: 'published')
                      .order(:end_of_registration)
  end


  def photo_or_default
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
    else
      ActionController::Base.helpers.asset_path('garnier.jpeg')
    end
  end

  def correct_mime_type_of_rule_document
    if rule_document.attached? && !rule_document.content_type.in?(%w(application/pdf))
      errors.add(:rule_document, 'Doit être un fichier PDF')
    end
  end

  def correct_mime_type_of_rule_document_english
    if rule_document_english.attached? && !rule_document_english.content_type.in?(%w(application/pdf))
      errors.add(:rule_document_english, 'Doit être un fichier PDF')
    end
  end


  def disciplines
    categories.pluck(:name).uniq
  end

  def days_remaining
    (end_of_registration.to_date - Date.today).to_i
  end

  def category_details
    categories.select(:name, :min_age, :max_age).map do |category|
      {
        name: category.name,
        min_age: category.min_age,
        max_age: category.max_age
      }
    end
  end

  def organism
    competition.organism
  end

  def max_prize_amount
    "#{categories.map(&:prizes).flatten.map(&:amount).max}€"
  end

  def max_prize_amount_label_for_card
    if categories.map(&:prizes).flatten.map(&:amount).max.positive?
      {icon: "fi fi-rs-trophy", label: "#{max_prize_amount} ", class: "text-primary h3 mb-0"}
    else
      nil
    end
  end

  def has_same_organisateur_as?(organisateur_id)
    Organisateur.joins(organisms: { competitions:  :edition_competitions })
                .where(edition_competitions: { id: id })
                .where(id: organisateur_id)
                .exists?
  end

  def sharable_link
    Rails.application.routes.default_url_options[:host] = Rails.env.development? ? 'localhost:3000' : 'musikast.com'
    Rails.application.routes.url_helpers.organism_competition_edition_competition_url(
      organism_id:,
      competition_id:,
      id:,
      locale: I18n.locale
    )
  end

  def sharable_link_english
    Rails.application.routes.default_url_options[:host] = Rails.env.development? ? 'localhost:3000' : 'musikast.com'
    Rails.application.routes.url_helpers.organism_competition_edition_competition_url(
      organism_id:,
      competition_id:,
      id:,
      locale: :en
    )
  end

  def qr_code
    qrcode = RQRCode::QRCode.new(sharable_link)
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    )
  end

  def qr_code_english
    qrcode = RQRCode::QRCode.new(sharable_link_english)
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    )
  end
end
