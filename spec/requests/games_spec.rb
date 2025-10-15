# spec/requests/games_spec.rb
require 'rails_helper'

RSpec.describe 'Games', type: :request do
  let!(:game) { Game.create! }
  
  describe 'GET /index' do
    it 'returns http success' do
      get games_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get game_path(game)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get new_game_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'creates a new game and redirects' do
      post games_path, params: { game: { style: 'short' } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get edit_game_path(game)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /update' do
    it 'updates the game and redirects' do
      patch game_path(game), params: { game: { status: :finished } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes the game and redirects' do
      delete game_path(game)
      expect(response).to have_http_status(:redirect)
    end
  end
end
