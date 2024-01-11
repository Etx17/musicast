class Performance < ApplicationRecord
  belongs_to :inscription
  belongs_to :tour

  # air_selection is Array of air ids, text type
end
