class InscriptionItemRequirement < ApplicationRecord
  belongs_to :inscription
  belongs_to :requirement_item
end
