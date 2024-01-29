class RequirementItem < ApplicationRecord
  belongs_to :category

  has_many :inscription_item_requirements, dependent: :destroy

  enum type_item: { youtube_link: 0, recommendation_letter_pdf: 1, parental_authorization_pdf: 2, motivation_essay: 3 }

  def self.text_items
    %w[youtube_link motivation_essay]
  end

  def self.pdf_items
    %w[recommendation_letter_pdf parental_authorization_pdf]
  end

  def is_pdf?
    RequirementItem.pdf_items.include?(self.type_item)
  end
end
