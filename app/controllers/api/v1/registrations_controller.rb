module Api
  module V1
    class RegistrationsController < Api::V1::BaseController
      skip_after_action :verify_authorized

      def create
        begin
          raise 'Password confirmation not included' unless params['user']['password_confirmation']

          user = User.create!(user_params)

          session[:user_id] = user.id
          render json: {
            logged_in: true,
            user: UserRepresenter.new(user).as_json
          }, status: :created
        rescue ActiveRecord::RecordInvalid => e
          render json: {
            error_message: e.message.split(':')&.last&.strip || 'Something went wrong'
          }, status: :unprocessable_entity
        rescue => e
          render json: {
            error_message: e.message
          }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :display_name)
      end
    end
  end
end
