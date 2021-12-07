module Api
  module V1
    class SessionsController < ApplicationController
      include CurrentUserConcern

      def create
        user = User.find_by(email: params['user']['email'])
                  .try(:authenticate, params['user']['password']) # This 'authenticate' method comes from having a 'password_digest' field and having 'has_secure_password' on 'User'

        if user
          session[:user_id] = user.id # This creates a cookie...
          render json: {
            logged_in: true,
            user: UserRepresenter.new(user).as_json
          }, status: :created
        else
          render json: { error_message: 'Unable to find user' }, status: :unauthorized
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
