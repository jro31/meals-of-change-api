class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params['user']['email'])
               .try(:authenticate, params['user']['password']) # This 'authenticate' method comes from having a 'password_digest' field and having 'has_secure_password' on 'User'

    if user
      session[:user_id] = user.id # This creates a cookie...
      render json: {
        status: :created,
        logged_in: true,
        user: user
      }
    else
      render json: { status: 401 }
    end
  end
end
