module Api
  module V1
    class TripsController < Api::V1::BaseController
      def index
        trips = Trip.ransack(search_params)
        trips.sorts = 'name asc' if trips.sorts.empty?

        @trips = trips.result(distinct: true)
                      .page(page_number)
                      .per(per_page_value)

        render json: {
          trips: @trips,
          meta: response_meta(@trips) 
        }, each_serializer: Api::V1::Trips::ListSerializer
      end

      def show
        @trip = Trip.find(params[:id])
        render json: @trip, serializer: Api::V1::Trips::DetailedSerializer
      end

      def create
        @trip = Trip.new(trip_params)
        
        if @trip.save
          render json: @trip,
                 status: :created,
                 serializer: Api::V1::Trips::DetailedSerializer
        else
          render json: @trip,
                 status: :unprocessable_entity,
                 serializer: ErrorsSerializer
        end
      end

      private

      def trip_params
        params.require(:trip).permit(:name, :image_url, :short_description, :long_description, :rating)
      end

      def search_params
        return {} if params[:q].blank?

        params.require(:q).permit(:name_cont_cs, :rating_gteq, :s)
      end
    end
  end
end