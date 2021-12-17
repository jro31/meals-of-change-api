module Api
  module V1
    class BaseController < ApplicationController
      include Pundit
      include CurrentUserConcern

      skip_before_action :verify_authenticity_token
      # The 'verify_authenticity_token' method checks that the user typing into a form is the real user (not sure how)
      # With an API, because that logic is happening in a separate app, we need to skip it here

      after_action :verify_authorized, except: :index, unless: :skip_after_action
      after_action :verify_policy_scoped, only: :index, unless: :skip_after_action

      rescue_from Pundit::NotAuthorizedError,   with: :user_not_authorized
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      private

      def user_not_authorized(exception)
        render json: {
          error_message: "Unauthorized #{exception.policy.class.to_s.underscore.camelize}.#{exception.query}"
        }, status: :unauthorized
      end

      def not_found(exception)
        render json: { error_message: exception.message }, status: :not_found
      end

      def skip_after_action
        @skip_after_action
      end
    end
  end
end
