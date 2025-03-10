class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  VALID_ZIPCODE_REGEX = /\A[0-9a-zA-Z]{5}\z/
  VALID_ADDRESS_REGEX = /\A[a-zA-Z0-9\s,.'-]*\z/

  validates :line1, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true
  validates :country, presence: true

end
