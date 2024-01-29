class Organisateur < ApplicationRecord
  has_many :organisms
  belongs_to :user
  has_many :competitions, through: :organisms

  accepts_nested_attributes_for :organisms
  after_create :create_empty_organism_associated

  def organism
    organisms.first
  end

  def create_empty_organism_associated
    Organism.create(organisateur_id: id, nom: "Mon organisme", description: "Description de mon organisme")
  end

end
