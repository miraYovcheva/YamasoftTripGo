FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "Trip #{n}" }
    image_url { "https://example.com/trip.jpg" }
    short_description { "A short trip description." }
    long_description { "A longer description of the trip." }
    rating { 5 }
  end
end