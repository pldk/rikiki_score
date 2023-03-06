# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players
  resources :games do
    resources :rounds
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'games#index'
end
