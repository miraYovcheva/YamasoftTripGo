require 'rails_helper'

RSpec.describe Trip, type: :model do
  subject { build(:trip) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_numericality_of(:rating).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(5) }
  end

  describe 'ransackable attributes' do
    it { expect(described_class).to respond_to(:ransackable_attributes) }
    it { expect(Trip.ransackable_attributes).to eq(%w[name rating created_at]) }
  end
end
