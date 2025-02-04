Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :events, only: [ :new, :edit, :create, :update, :destroy, :show ] do
    patch :publish, on: :member

    resources :ticket_batches, only: [ :index, :new, :create ]

    resources :schedules, only: [ :show ] do
      resources :schedule_items, as: :items, only: [ :new, :create ]
    end
  end

  resources :event_places, only: [ :new, :create, :index, :show, :edit, :update, :destroy ] do
    resources :event_place_recommendations, as: :recommendations, only: [ :new, :create ]
  end

  resources :keywords, only: [ :new, :create ]

  resources :categories, only: [ :index, :new, :create, :show, :update ]
  get "dashboard" => "dashboard#index"

  namespace :api do
    namespace :v1 do
      resources :events, param: :code, only: [ :index, :show ] do
        resources :ticket_batches, param: :code, only: [ :index, :show ]
      end
      resources :speakers, only: [ :create ], param: :code do
        get "events", on: :member
        get "schedules/:event_code", to: "speakers#schedules", as: :schedules
      end
    end
  end
end
