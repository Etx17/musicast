class ConvocationBulkJob < ApplicationJob
  queue_as :default

  def perform(tour, config)
    # Do something later
    tour.performances.where(is_qualified_for_current_tour: true).each do |performance|
      ConvocationMailer.with(performance: performance, config: config).convocation_email.deliver_later
    end
  end
end
