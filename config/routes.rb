Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :events do
    patch :publish, on: :member

    resources :ticket_batches, only: [ :index, :new, :create ]

    resources :schedules, only: [ :edit, :update, :show ] do
      resources :schedule_items, as: :items, only: [ :new, :create ]
    end
  end

  resources :keywords, only: [ :new, :create ]

  resources :categories, only: [ :index, :new, :create, :show, :update ]
  get "dashboard" => "dashboard#index"

  namespace :api do
    namespace :v1 do
      resources :events, param: :code, only: [ :index, :show ] do
        resources :ticket_batches, param: :code, only: [ :index, :show ]
      end
      resources :speakers, only: [ :create ], param: :token do
        get "events", on: :member
        get "schedules/:event_code", to: "speakers#schedules", as: :schedules
      end
    end
  end
end
