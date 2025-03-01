class Document < ApplicationRecord
  belongs_to :competition
  belongs_to :user
  belongs_to :parent, polymorphic: true

  enum :document_type, {
    program: 0,
    rules: 1,
    proof_of_id: 2,
    autre: 3
  }
end
