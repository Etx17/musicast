class ProgrammeRequirement < ApplicationRecord
  has_many :imposed_works
  has_many :choice_imposed_works
  has_many :free_choices
  has_many :semi_imposed_works
  belongs_to :category

  def list_titles_and_guidelines
    {
      imposed_works: imposed_works.pluck(:title, :guidelines),
      choice_imposed_works: choice_imposed_works.pluck(:title, :guidelines),
      free_choices: free_choices.pluck(:number, :max_length_minutes),
      semi_imposed_works: semi_imposed_works.pluck(:guidelines, :number, :max_length_minutes)
    }
  end
end
