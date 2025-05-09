# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players
  resources :games do
    resources :rounds
    get 'add_player', to: 'games/game_id/add_player'
    get 'remove_player', to: 'games/game_id/add_player'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'games#index'
end
