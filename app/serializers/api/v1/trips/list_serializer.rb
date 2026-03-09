module Api
  module V1
    module Trips
      class ListSerializer < BaseSerializer
        attributes :id, :name, :image_url, :short_description, :rating, :created_at
      end
    end
  end
end