class RequirementItem < ApplicationRecord
  belongs_to :category

  has_many :inscription_item_requirements, dependent: :destroy
  # Dans _form inscription on utilise ces références
  def self.item_types_list
    [ 'YouTube Link', 'Recommendation Letter PDF', 'Parental authorization PDF', 'Motivation Essay', 'Diploma PDF', 'Portrait', 'Artistic Photo']
  end
end
