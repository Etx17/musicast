class Document < ApplicationRecord
  belongs_to :competition
  belongs_to :user

  belongs_to :parent, polymorphic: true
end
