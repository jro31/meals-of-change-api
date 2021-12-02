class RegistrationsController < ApplicationController
  def create
    user = User.create!(
      email: params['user']['email'],
      password: params['user']['password'],
      password_confirmation: params['user']['password_confirmation']
    )
    # Rails requires a 'password_confirmation'.
    # However, if you don't want the user to have to fill-out a 'Password confirmation' field,
    # you can instead have 'password_confirmation: params['user']['password']'

    if user
      session[:user_id] = user.id
      render json: {
        status: :created,
        user: user
      }
    else
      render json: { status: 500 }
    end
  end
end
