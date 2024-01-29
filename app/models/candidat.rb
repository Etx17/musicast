class Candidat < ApplicationRecord
  belongs_to :user
  has_many :inscriptions, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :educations, dependent: :destroy

  has_one_attached :portrait
  has_one_attached :artistic_photo
  has_one_attached :banner

  has_many_attached :diplomas

  accepts_nested_attributes_for :experiences
  accepts_nested_attributes_for :educations

  validate :correct_document_mime_type
  validate :portrait_file_size, :portrait_file_format, :portrait_dimensions

  def has_minimum_informations_for_inscription?
    self.first_name.present? &&
    self.last_name.present? &&
    self.bio.present? &&
    self.short_bio.present? &&
    self.medium_bio.present? &&
    self.long_bio.present? &&
    self.repertoire.present? &&
    self.portrait.attached? &&
    self.birthdate &&
    self.artistic_photo.attached?
  end

  private

  def correct_document_mime_type
    diplomas.each do |diploma|
      if !diploma.blob.content_type.in?(%w(application/pdf))
        diploma.purge # delete the uploaded file
        errors.add(:diplomas, 'Must be a PDF file')
      end
    end
  end

  def portrait_file_size
    if portrait.attached? && portrait.blob.byte_size > 1.megabytes
      errors.add(:portrait, 'is too big')
    end
  end

  def portrait_file_format
    if portrait.attached? && !portrait.blob.content_type.starts_with?('image/jpeg')
      errors.add(:portrait, 'needs to be a JPEG image')
    end
  end

  def portrait_dimensions
    if portrait.attached?
      dimensions = ActiveStorage::Analyzer::ImageAnalyzer.new(portrait.blob).metadata[:dimensions]

      if dimensions[:width] < 1200 || dimensions[:height] < 1800
        errors.add(:portrait, 'needs to be at least 4x6 inches at 300dpi')
      end
    end
  end
end
