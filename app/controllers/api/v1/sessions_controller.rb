module Api
  module V1
    class SessionsController < Api::V1::BaseController
      skip_after_action :verify_authorized

      def create
        begin
          # TODO - Test if this is case-insensitive or not (for example, does 'J@j.j' work?)
          # If not, lowercase the email in the params before trying to authenticate
          user = User.find_by(email: params['user']['email'])
                     .try(:authenticate, params['user']['password'])

          raise 'Incorrect username/password' unless user

          # TODO - Currently the cookie is created for a "session" - Should it instead be created for an amount of time?
          # (also make any updates in the registrations controller)
          session[:user_id] = user.id # This creates a cookie...
          render json: {
            logged_in: true,
            user: UserRepresenter.new(user).as_json
          }, status: :created
        rescue => e
          render json: { error_message: e.message }, status: :unauthorized
        end
      end

      def logged_in
        if @current_user
          render json: {
            logged_in: true,
            user: UserRepresenter.new(@current_user).as_json
          }, status: :ok
        else
          render json: {
            logged_in: false
          }, status: :ok
        end
      end

      def logout
        reset_session
        render json: { logged_out: true }, status: :ok
      end
    end
  end
end
