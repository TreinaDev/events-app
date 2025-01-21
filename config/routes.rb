Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :events, only: [ :index, :new, :create, :show, :destroy ] do
    patch :publish, on: :member
  end

  resources :categories, only: [ :index, :new, :create ]
  get "dashboard" => "dashboard#index"
end
