module Api
  module V1
    class AccountsController < Api::V1::BaseController
      # GET /api/v1/account
      def show
        begin
          authorize User, policy_class: AccountPolicy

          render json: {
            user: UserRepresenter.new(current_user).as_json
          }, status: :ok
        rescue Pundit::NotAuthorizedError
          render json: {
            error_message: 'User must be logged-in to access account'
          }, status: :unauthorized
        rescue => e
          render json: {
            error_message: e.message
          }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/accounts/:id
      def update
        # TODO
      end
    end
  end
end
