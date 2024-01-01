class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  geocoded_by :full_address
end
