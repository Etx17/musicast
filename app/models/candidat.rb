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

  def has_minimum_informations_for_inscription?
    self.first_name.present? && self.last_name.present? && self.bio.present? && self.short_bio.present? && self.medium_bio.present? && self.long_bio.present? && self.repertoire.present? && self.portrait.attached? && self.birthdate && self.artistic_photo.attached?
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
end
