class ChoiceImposedWorkAir < ApplicationRecord
  belongs_to :choice_imposed_work
  belongs_to :inscription
  belongs_to :air

  # Voir si ca contraint bien l'utilisateur a pas pouvoir choisir plusieurs fois le même air dans un choice imposed work.
  after_commit :check_for_changes
  validates :air_id, presence: true
  validates :air_id, uniqueness: { scope: :inscription_id, message: ": Vous ne pouvez pas choisir le même air plus d'une fois." }, on: :update

  def check_for_changes
    if saved_change_to_air_id?
      # update each inscription.performance's ordered_air_selection to remove the air that was just removed
      # update each inscription.performance's ordered_air_selection to add the air that was just added
      old_air_id, new_air_id = saved_change_to_air_id

      inscription.performances.each do |performance|
        ordered_air_selection = performance.ordered_air_selection

        # Remove the old air_id from the ordered_air_selection
        ordered_air_selection.delete(old_air_id.to_s)

        # Add the new air_id to the ordered_air_selection
        ordered_air_selection << new_air_id.to_s

        # Save the updated ordered_air_selection
        performance.update(ordered_air_selection: ordered_air_selection.uniq)
      end
    end
  end
end
