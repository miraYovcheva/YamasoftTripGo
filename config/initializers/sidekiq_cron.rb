# config/initializers/sidekiq_cron.rb
# Only load Sidekiq Cron when Redis is available (avoids crashing rails server when Redis is down)
begin
  require "sidekiq/cron"
  Sidekiq::Cron::Job.load_from_hash(
    "trip_ratings_summary" => {
      "cron" => "0 2 * * *",  # 2:00 AM every day
      "class" => "TripsRatingSummaryJob"
    }
  )
rescue RedisClient::CannotConnectError, Errno::ECONNREFUSED => e
  Rails.logger.warn "[sidekiq_cron] Redis not available - cron jobs not loaded: #{e.message}"
end