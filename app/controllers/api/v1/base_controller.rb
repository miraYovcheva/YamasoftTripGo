module Api
  module V1
    class BaseController < ApplicationController
      include Pundit::Authorization
      skip_before_action :verify_authenticity_token

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      rescue_from StandardError do |e|
        Rails.logger.error(e)
        render json: { errors: ["An unexpected error occurred"] }, status: :internal_server_error
      end

      rescue_from ActiveRecord::RecordNotFound do
        render json: { errors: ['Record not found'] }, status: :not_found
      end

      def response_meta(collection)
        return {} unless action_name == 'index'
        return {} unless collection.respond_to?(:current_page)
      
        {
          current_page: collection.current_page,
          per_page: collection.limit_value,
          total_pages: collection.total_pages,
          total_count: collection.total_count,
          next_page: collection.next_page,
          prev_page: collection.prev_page
        }
      end
      
      def page_number
        [(params.dig(:page, :number).presence || params[:page] || 1).to_i, 1].max
      end
      
      def per_page_value
        [[(params.dig(:page, :size).presence || params[:per_page] || 10).to_i, 1].max, 100].min
      end
    end
  end
end