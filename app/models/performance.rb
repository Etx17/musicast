class Performance < ApplicationRecord
  belongs_to :inscription
  belongs_to :tour
  belongs_to :pianist_accompagnateur, optional: true
  has_one :tour_requirement, through: :tour
  has_one :candidate_rehearsal, dependent: :destroy
  # validate :performance_has_correct_duration
  has_many_attached :scores, dependent: :destroy
  delegate :candidat, to: :inscription


  enum :status, {
    draft: 0,
    in_review: 1,
    accepted: 2,
    rejected: 3,
    changes_requested: 4
  }
  before_save :update_ordered_air_selection


  def imposed_air_selection
    tour&.imposed_air_selection
  end

  def airs
    air_ids = air_selection
    if air_ids.empty?
      air_ids = ordered_air_selection
    end
    air_ids += imposed_air_selection if imposed_air_selection

    air_ids += ordered_air_selection if ordered_air_selection&.count > ((air_selection&.count || 0 ) + ( imposed_air_selection.present? ? imposed_air_selection.count : 0))

    Air.where(id: air_ids.uniq)
  end


  def airs_titles
    airs.map(&:title)
  end

  def minutes
    airs.sum(&:length_minutes)
  end



  def update_ordered_air_selection
    # Convert all IDs to strings for consistent comparison
    string_air_selection = air_selection.map(&:to_s)
    string_imposed_selection = imposed_air_selection&.map(&:to_s) || []

    # If ordered_air_selection is empty, initialize it
    if ordered_air_selection.blank?
      self.ordered_air_selection = (string_air_selection + string_imposed_selection).uniq
      return self.ordered_air_selection
    end

    # Convert ordered_air_selection to strings for consistent comparison
    string_ordered_selection = ordered_air_selection.map(&:to_s)

    # If air_selection has changed
    if air_selection_changed?
      # Combine current air_selection and imposed_air_selection
      combined_selection = string_air_selection + string_imposed_selection

      # Remove any IDs from ordered_air_selection that are not in the combined_selection
      string_ordered_selection.select! { |id| combined_selection.include?(id) }

      # Add any new IDs from air_selection to ordered_air_selection
      new_ids = string_air_selection - string_ordered_selection
      string_ordered_selection.concat(new_ids)

      # Update ordered_air_selection with the new array of string IDs
      self.ordered_air_selection = string_ordered_selection
    end
  end

  def assign_pianist_accompagnateur(pianist_accompagnateur_id)
    self.update(pianist_accompagnateur_id: pianist_accompagnateur_id)
  end


  # Used in policy
  def has_same_organisateur_as?(organisateur_id)
    Organism.joins({competitions: { edition_competitions: { categories: { inscriptions: :performances } } }})
            .where(performances: { id: id })
            .where(organisateur_id: organisateur_id)
            .exists?
  end

  def has_incorrect_duration?
    false
    if minutes >= tour.tour_requirement.max_duration_minute
      return true
    end
    if minutes <= tour.tour_requirement.min_duration_minute
      return true
    end
  end

  # Add this method to ensure air_selection is always an array of strings
  def air_selection=(values)
    super(values.map(&:to_s))
  end

end
