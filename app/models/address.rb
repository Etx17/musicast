class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  VALID_ZIPCODE_REGEX = /\A[0-9a-zA-Z]{5}\z/
  VALID_ADDRESS_REGEX = /\A[a-zA-Z0-9\s,.'-]*\z/

  validates :line1, presence: true, format: { with: VALID_ADDRESS_REGEX }
  validates :city, presence: true, format: { with: VALID_ADDRESS_REGEX }
  validates :zipcode, presence: true, format: { with: VALID_ZIPCODE_REGEX }
  validates :country, presence: true, format: { with: VALID_ADDRESS_REGEX }

end
