module Api
  module V1
    module Trips
      class DetailedSerializer < BaseSerializer
        attributes :id, :name, :image_url, :short_description, :long_description, :rating,
          :created_at, :updated_at

        def created_at
          object.created_at.strftime("%Y-%m-%d %H:%M:%S")
        end

        def updated_at
          object.updated_at.strftime("%Y-%m-%d %H:%M:%S")
        end
      end
    end
  end
end
