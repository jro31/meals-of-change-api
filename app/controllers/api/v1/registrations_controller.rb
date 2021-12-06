module Api
  module V1
    class RegistrationsController < ApplicationController
      def create
        begin
          user = User.create!(
            email: params['user']['email'],
            password: params['user']['password'],
            password_confirmation: params['user']['password_confirmation']
          )

          session[:user_id] = user.id
          render json: {
            logged_in: true,
            user: user
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
    end
  end
end
