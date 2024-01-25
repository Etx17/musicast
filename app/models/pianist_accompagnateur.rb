class PianistAccompagnateur < ApplicationRecord
  has_many :performances
  belongs_to :organism
end
