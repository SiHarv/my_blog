Rails.application.routes.draw do
  get "profile/show"
  mount Motor::Admin => "/motor_admin"
  get "votes/create"
  get "votes/destroy"
  devise_for :users
  resource :profile, only: [ :show ], controller: "profile"
  # RESTful routes for posts
  resources :posts do
    resources :comments, only: [ :create, :destroy, :edit, :update ]
    resource :votes, only: [ :create ]
  end
  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
