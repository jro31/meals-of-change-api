if Rails.env == 'production'
  Rails.application.config.session_store :cookie_store, key: "_authentication_app", domain: "api.mealsofchange.com" # Update this to whatever your backend URL is
else
  Rails.application.config.session_store :cookie_store, key: "_authentication_app"
end
