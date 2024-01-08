class InscriptionOrder < ApplicationRecord
  belongs_to :user
  belongs_to :inscription

  enum state: { pending: 0, completed: 1, failed: 2 }
  monetize :amount_cents
end
