class RequirementItem < ApplicationRecord
  belongs_to :category

  has_many :inscription_item_requirements, dependent: :destroy

  enum type_item: { youtube_link: 0, recommendation_letter: 1, parental_authorization: 2, motivation_essay: 3 }

  def self.text_items
    %w[youtube_link motivation_essay]
  end

  def self.pdf_items
    %w[recommendation_letter parental_authorization]
  end

  def is_pdf?
    RequirementItem.pdf_items.include?(self.type_item)
  end
end
