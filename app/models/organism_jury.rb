class OrganismJury < ApplicationRecord
  belongs_to :organism
  belongs_to :jury

  validates :jury_id, uniqueness: { scope: :organism_id }
  validates :jury_id, presence: true
end
