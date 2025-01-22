Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :events, only: [ :index, :new, :create, :show ] do
    patch :publish, on: :member

    resources :schedules, only: [ :new, :create, :edit, :update, :show ]
  end

  resources :categories, only: [ :index, :new, :create ]
  get "dashboard" => "dashboard#index"
end
