# script to update model associations
require 'active_support/core_ext/string'

model_associations = {
  'organisateur' => ['has_many :organisms'],
  'candidat' => [],
  'jury' => [],
  'partner' => [],
  'organism' => ['has_many :competitions', 'has_many :partners'],
  'competition' => ['has_many :edition_competitions'],
  'edition_competition' => ['has_many :categories'],
  'category' => ['has_many :tours', 'has_many :requirement_items', 'has_many :inscriptions'],
  'tour' => ['has_many :programme_requirements', 'has_many :performances'],
  'programme_requirement' => ['has_many :imposed_works', 'has_many :choice_imposed_works', 'has_many :free_choices',
                              'has_many :semi_imposed_works'],
  'air' => ['has_many :imposed_work_airs', 'has_many :choice_imposed_work_airs', 'has_many :free_choice_airs',
            'has_many :semi_imposed_work_airs', 'has_many :candidate_program_airs'],
  'imposed_work' => ['has_many :imposed_work_airs', 'has_many :airs, through: :imposed_work_airs'],
  'choice_imposed_work' => ['has_many :choice_imposed_work_airs', 'has_many :airs, through: :choice_imposed_work_airs'],
  'free_choice' => ['has_many :free_choice_airs', 'has_many :airs, through: :free_choice_airs'],
  'semi_imposed_work' => ['has_many :semi_imposed_work_airs', 'has_many :airs, through: :semi_imposed_work_airs'],
  'inscription' => ['has_many :performances', 'has_one :candidate_program'],
  'candidate_program' => ['has_many :candidate_program_airs', 'has_many :airs, through: :candidate_program_airs'],
  'performance' => ['has_many :tour'],
  'imposed_work_air' => [],
  'choice_imposed_work_air' => [],
  'free_choice_air' => [],
  'semi_imposed_work_air' => [],
  'candidate_program_air' => []
}

model_associations.each do |model, associations|
  file_path = "app/models/#{model}.rb"
  if File.exist?(file_path)
    file_contents = File.read(file_path)

    # Check if the model name contains an underscore
    model_name = model.include?('_') ? model.underscore : model

    # Find the class definition for the model
    if file_contents =~ /class #{model_name.classify} < ApplicationRecord/
      updated_contents = file_contents.gsub(/class #{model_name.classify} < ApplicationRecord/) do |match|
        "#{match}\n  #{associations.join("\n  ")}"
      end

      File.open(file_path, 'w') do |file|
        file.puts updated_contents
      end
    else
      puts "Class definition not found in: #{file_path}"
    end
  else
    puts "File not found: #{file_path}"
  end
end
