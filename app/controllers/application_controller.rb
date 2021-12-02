class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  # The 'verify_authenticity_token' method checks that the user typing into a form is the real user (not sure how)
  # With an API, because that logic is happening in a separate app, we need to skip it here
end
