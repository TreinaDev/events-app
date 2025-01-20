Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :categories, only: [ :index, :new, :create ]
  get "dashboard" => "dashboard#index"
end
