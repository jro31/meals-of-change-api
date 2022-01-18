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
        begin
          raise 'Password confirmation not included' if params['user']['password'] && !params['user']['password_confirmation']
          raise 'New password not included' if params['user']['password_confirmation'] && !params['user']['password']

          @user = User.find(params[:id])
                      .try(:authenticate, params['user']['existing_password'])
          authorize @user, policy_class: AccountPolicy

          @user.update!(user_params)

          render json: {
            user: UserRepresenter.new(@user).as_json
          }, status: :ok
        rescue Pundit::NotAuthorizedError
          render json: {
            error_message: 'Not authorized to update account'
          }, status: :unauthorized
        rescue => e
          @skip_after_action = true
          render json: {
            error_message: e.message
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:password, :password_confirmation, :display_name, :twitter_handle, :instagram_username)
      end
    end
  end
end
