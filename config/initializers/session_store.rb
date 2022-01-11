if Rails.env == 'production'
  Rails.application.config.session_store :cookie_store, key: "_meals_of_change", domain: "api.mealsofchange.com"
else
  Rails.application.config.session_store :cookie_store, key: "_meals_of_change"
end
