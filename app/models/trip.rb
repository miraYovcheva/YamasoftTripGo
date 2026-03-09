class Trip < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  def self.ransackable_associations(_auth_object = nil)
    []
  end
    
  def self.ransackable_attributes(auth_object = nil)
    %w[name rating created_at]
  end

  def self.generate_rating_summary
    trips = Trip.all
    return { message: 'No trips found' } if trips.empty?

    ratings = trips.pluck(:rating)
    ratings = trips.pluck(:rating).compact
    avg = (ratings.sum.to_f / ratings.size).round(2)
    by_rating = (1..5).to_h { |r| [r, trips.where(rating: r).count] }

    {
      total_trips: trips.count,
      average_rating: avg,
      by_rating: by_rating,
      top_rated: trips.order(rating: :desc).limit(5).pluck(:name, :rating),
      generated_at: Time.current.iso8601
    }
  end
end