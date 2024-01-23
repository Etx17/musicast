class Performance < ApplicationRecord
  belongs_to :inscription
  belongs_to :tour

  has_one :tour_requirement, through: :tour

  delegate :candidat, to: :inscription


  enum status: {
    draft: 0,
    in_review: 1,
    accepted: 2,
    rejected: 3
  }
  before_save :update_ordered_air_selection

  def imposed_air_selection
    tour&.imposed_air_selection
  end

  def airs
    airs = Air.where(id: air_selection)
    imposed_air_selection&.each do |air_id|
      airs = airs.or(Air.where(id: air_id))
    end

    airs
  end


  def airs_titles
    airs.map(&:title)
  end

  def minutes
    airs.sum(&:length_minutes)
  end


  def update_ordered_air_selection
    # Si jamais pas d'ordrered air selection, ca l'initialise avec air_selection + imposed_air_selection
    if ordered_air_selection.empty?
      self.ordered_air_selection = (air_selection + (imposed_air_selection || [])).uniq
      self.ordered_air_selection = air_selection | imposed_air_selection
      return self.ordered_air_selection
    end

    # Si air_selection a changé, je dois soit ajouter soit supprimer, bref mettre à jour ordered_air_selection
    if air_selection_changed?
      # Combine current air_selection and imposed_air_selection
      combined_selection = air_selection + imposed_air_selection

      # Remove any IDs from ordered_air_selection that are not in the combined_selection
      self.ordered_air_selection.select! { |id| combined_selection.include?(id) }

      # Add any new IDs from air_selection to ordered_air_selection
      new_ids = air_selection - ordered_air_selection
      self.ordered_air_selection.concat(new_ids)
      self.ordered_air_selection
    end

  end

  private



end
