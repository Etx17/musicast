class AddFinalPerformanceSubmissionDeadlineToTours < ActiveRecord::Migration[7.0]
  def change
    add_column :tours, :final_performance_submission_deadline, :datetime
  end
end
