Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :events, only: [ :index, :new, :create, :show ] do
    patch :publish, on: :member

    resources :schedules, only: [ :new, :create, :edit, :update ]
  end

  resources :keywords, only: [ :new, :create ]

  resources :categories, only: [ :index, :new, :create, :show, :update ]
  get "dashboard" => "dashboard#index"
end
