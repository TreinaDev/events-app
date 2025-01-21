Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :events, only: [ :index, :new, :create, :show ] do
    patch :publish, on: :member
  end

  resources :keywords, only: [ :new, :create ]

  resources :categories, only: [ :index, :new, :create ]
  get "dashboard" => "dashboard#index"
end
