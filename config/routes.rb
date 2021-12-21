Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :registrations, only: [:create]
      resources :sessions, only: [:create]
      get :logged_in, to: 'sessions#logged_in'
      delete :logout, to: 'sessions#logout'

      resources :recipes, only: [:index, :show, :create]
      post :presigned_url, to: 'direct_upload#create'
      resources :tags, only: [:index]
    end
  end

  root to: "static#home"
end
