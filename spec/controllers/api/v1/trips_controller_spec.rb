# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TripsController, type: :controller do
  describe 'GET /api/v1/trips' do
    before { create_list(:trip, 3, rating: 5) }

    it 'returns a success response' do
      get :index
      expect(response).to be_successful

      response_data = JSON.parse(response.body)

      expect(response_data['trips']).to be_an(Array)
      expect(response_data['trips'].length).to eq(3)
      expect(response_data['meta']).to include(
        'current_page',
        'per_page',
        'total_count',
        'total_pages',
        'next_page',
        'prev_page'
      )
    end

    it 'returns filtered trips by rating' do
      create_list(:trip, 2, rating: 2)

      get :index, params: { q: { rating_gteq: 3 } }
      expect(response).to be_successful

      response_data = JSON.parse(response.body)
      expect(response_data['trips'].length).to eq(3)

      get :index, params: { q: { rating_gteq: 2 } }
      expect(response).to be_successful

      response_data = JSON.parse(response.body)
      expect(response_data['trips'].length).to eq(5)
    end

    it 'returns filtered trips by name' do
      create(:trip, name: 'Paris Trip')
      create(:trip, name: 'London Trip')

      get :index, params: { q: { name_cont: 'Paris' } }
      expect(response).to be_successful

      response_data = JSON.parse(response.body)
      expect(response_data['trips'].length).to eq(1)
    end

    it 'returns sorted trips by name' do
      create(:trip, name: 'Paris Trip', rating: 1)
      create(:trip, name: 'London Trip', rating: 2)

      get :index, params: { q: { s: 'rating asc' } }
      expect(response).to be_successful

      response_data = JSON.parse(response.body)
      expect(response_data['trips'][0]['rating']).to eq(1)
      expect(response_data['trips'][1]['rating']).to eq(2)
      expect(response_data['trips'][2]['rating']).to eq(5)
    end
  end

  describe 'GET /api/v1/trips/:id' do
    it 'returns a success response' do
      trip = create(:trip, rating: 5)

      get :show, params: { id: trip.id }
      expect(response).to be_successful

      json = response.parsed_body
      expect(json['name']).to eq(trip.name)
      expect(json['rating']).to eq(5)
    end

    context 'when record is not found' do
      it 'returns 404 and an error message' do
        get :show, params: { id: 999_999 }
        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
        expect(json['errors'].join).to match('Record not found')
      end
    end
  end

  describe 'POST /api/v1/trips' do
    let(:valid_attributes) do
      {
        name: 'Alps Adventure',
        image_url: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
        short_description: 'Mountain trip.',
        long_description: 'A week in the Alps.',
        rating: 3
      }
    end

    context 'with valid input' do
      it 'creates a trip and returns 201' do
        expect {
          post :create, params: { trip: valid_attributes }, format: :json
        }.to change(Trip, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Alps Adventure')
        expect(json['rating']).to eq(3)
        expect(json['short_description']).to eq('Mountain trip.')
        expect(json['long_description']).to eq('A week in the Alps.')
        expect(json['image_url']).to eq('https://images.unsplash.com/photo-1501785888041-af3ef285b470')
      end
    end

    context 'with invalid input' do
      it 'returns 422 when name is blank' do
        post :create, params: { trip: valid_attributes.merge(name: '') }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
        expect(json['errors'].join).to match("Name can't be blank")
      end

      it 'returns 422 when name is duplicated' do
        create(:trip, name: 'Existing Trip', rating: 4)
        post :create, params: { trip: valid_attributes.merge(name: 'Existing Trip') }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
        expect(json['errors'].join).to match('Name has already been taken')
      end

      it 'returns 422 when rating is missing' do
        post :create, params: { trip: valid_attributes.except(:rating) }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
      end

      it 'returns 422 when rating is out of range' do
        post :create, params: { trip: valid_attributes.merge(rating: 10) }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
        expect(json['errors'].join).to include('Rating must be less than or equal to 5')
      end

      it 'returns 422 when rating is below 1' do
        post :create, params: { trip: valid_attributes.merge(rating: 0) }, format: :json

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
        expect(json['errors'].join).to include('Rating must be greater than or equal to 1')
      end
    end
  end
end
