class InscriptionItemRequirement < ApplicationRecord
  belongs_to :inscription
  belongs_to :requirement_item

  has_one_attached :submitted_file

end
