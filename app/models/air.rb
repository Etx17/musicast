class Air < ApplicationRecord
  has_many :imposed_work_airs
  has_many :free_choice_airs
  has_many :semi_imposed_work_airs
  has_many :candidate_program_airs
  belongs_to :imposed_work, optional: true
  belongs_to :choice_imposed_work, optional: true
end
