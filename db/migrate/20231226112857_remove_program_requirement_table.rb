class RemoveProgramRequirementTable < ActiveRecord::Migration[7.0]
  def change
    remove_reference :imposed_works, :programme_requirement, index: true, foreign_key: true
    remove_reference :semi_imposed_works, :programme_requirement, index: true, foreign_key: true
    remove_reference :free_choices, :programme_requirement, index: true, foreign_key: true
    remove_reference :choice_imposed_works, :programme_requirement, index: true, foreign_key: true
  end
end
