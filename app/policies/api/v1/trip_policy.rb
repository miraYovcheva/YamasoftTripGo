module Api
  module V1
    class TripPolicy < ApplicationPolicy
      def index?
        true
      end

      def show?
        true
      end

      def create?
        true
      end

      class Scope < Scope
        def resolve
          scope.all
        end
      end
    end
  end
end
