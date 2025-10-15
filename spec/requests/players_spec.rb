# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players', type: :request do
  before(:each) { host! 'example.com' }

  let!(:game) { Game.create!(style: 'short') }
  let!(:player) { Player.create!(name: 'Alice') }

  describe 'GET /index' do
    it 'returns http success' do
      get game_players_path(game)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get player_path(player)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get new_player_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'creates a player and redirects' do
      post players_path, params: { player: { name: 'Bob' } }
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to include('Bob')
    end
  end

  # describe 'GET /edit' do
  #   it 'returns http success' do
  #     get '/players/edit'
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe 'GET /update' do
  #   it 'returns http success' do
  #     get '/players/update'
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  describe 'GET /destroy' do
    it 'returns http success' do
      delete game_player_path(game, player)
      expect(response).to have_http_status(:redirect)
    end
  end
end
