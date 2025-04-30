class Candidat < ApplicationRecord
  belongs_to :user
  has_many :inscriptions, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy

  has_one_attached :portrait, dependent: :destroy
  has_one_attached :artistic_photo, dependent: :destroy
  has_one_attached :banner, dependent: :destroy
  has_one_attached :cv_english, dependent: :destroy

  has_many_attached :diplomas

  accepts_nested_attributes_for :experiences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :educations, allow_destroy: true, reject_if: :all_blank


  # Validations to comment for seed
  # validate :correct_document_mime_type
  # validate :correct_portrait_mime_type
  # validate :correct_artistic_photo_mime_type
  # validate :portrait_attached, :artistic_photo_attached


  # validates :first_name, :last_name, :birthdate, :short_bio, :medium_bio, :long_bio, :repertoire, presence: true
  # validates_length_of :first_name, :last_name, minimum: 2, maximum: 30
  # validates_length_of :short_bio, maximum: 300
  # validates_length_of :medium_bio, maximum: 1000
  # validates_length_of :long_bio, maximum: 3000
   # validates_length_of :short_bio_en, maximum: 300
  # validates_length_of :medium_bio_en, maximum: 1000
  # validates_length_of :long_bio_en, maximum: 3000

  def full_name
    "#{first_name} #{last_name}"
  end


  def portrait_attached
    errors.add(:portrait, "Portrait must be attached") unless portrait.attached?
  end

  def artistic_photo_attached
    errors.add(:artistic_photo, "Artistic photo must be attached") unless artistic_photo.attached?
  end

  def portrait_or_default
    if portrait.attached?
      return portrait
    else
      raise
      return Rails.root.join('app', 'assets', 'images', 'default_portrait.jpg').open
    end
  end

  def has_minimum_informations_for_inscription?
    self.first_name.present? &&
    self.last_name.present? &&
    self.short_bio.present? &&
    self.medium_bio.present? &&
    self.long_bio.present? &&
    self.repertoire.present? &&
    self.portrait.attached? &&
    self.birthdate &&
    self.artistic_photo.attached?
  end

  def age
    return unless birthdate.present?
    now = Time.now.utc.to_date
    now.year - birthdate.year - (birthdate.to_date.change(year: now.year) > now ? 1 : 0)
  end

  private

  def correct_artistic_photo_mime_type
    if artistic_photo.attached? && !artistic_photo.content_type.in?(%w(image/jpeg image/png))
      artistic_photo.purge
      errors.add(:artistic_photo, 'Must be a JPEG or PNG')
    end
  end

  def correct_portrait_mime_type
    if portrait.attached? && !portrait.content_type.in?(%w(image/jpeg image/png))
      portrait.purge
      errors.add(:portrait, 'Must be a JPEG or PNG')
    end
  end

  def correct_document_mime_type
    diplomas.each do |diploma|
      if !diploma.blob.content_type.in?(%w(application/pdf))
        diploma.purge # delete the uploaded file
        errors.add(:diplomas, 'Must be a PDF file')
      end
    end
  end

end
