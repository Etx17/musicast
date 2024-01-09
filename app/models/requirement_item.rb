class RequirementItem < ApplicationRecord
  belongs_to :category

  # Dans _form inscription on utilise ces références
  def self.item_types_list
    [ 'YouTube Link', 'Recommendation Letter PDF', 'Parental authorization PDF', 'Motivation Essay', 'Other PDF File']
  end
end
