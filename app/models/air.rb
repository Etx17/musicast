class Air < ApplicationRecord
  has_many :free_choice_airs, dependent: :destroy
  has_many :candidate_program_airs, dependent: :destroy
  belongs_to :imposed_work, optional: true
  belongs_to :choice_imposed_work, optional: true
  belongs_to :semi_imposed_work, optional: true
end
