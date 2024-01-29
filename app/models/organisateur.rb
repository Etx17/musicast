class Organisateur < ApplicationRecord
  has_many :organisms
  belongs_to :user
  has_many :competitions, through: :organisms

  accepts_nested_attributes_for :organisms


  def organism
    organisms&.first
  end

end
