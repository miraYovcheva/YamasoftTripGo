class TripsRatingSummaryJob < ApplicationJob
  queue_as :default

  def perform
    summary = Trip.generate_rating_summary
    Rails.logger.info "[TripRatingsSummary] #{summary.to_json}"
  end
end
