Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  get "dashboard" => "dashboard#index"
end
