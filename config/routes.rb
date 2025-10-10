# frozen_string_literal: true

Rails.application.routes.draw do
  root 'games#index'

  resources :games do
    member do
      post :start
    end

    resources :players, only: %i[index create destroy], controller: 'games/players'
    resources :rounds, except: %i[destroy] do
      resources :predictions, only: %i[edit update]
    end
  end
  resources :players, only: [:create]
end
