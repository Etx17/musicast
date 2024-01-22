class Air < ApplicationRecord
  has_many :candidate_program_airs, dependent: :destroy
  has_many :choice_imposed_work_airs
  has_many :choice_imposed_works, through: :choice_imposed_work_airs

  belongs_to :imposed_work, optional: true
  belongs_to :choice_imposed_work, optional: true
  belongs_to :semi_imposed_work, optional: true

  
end
