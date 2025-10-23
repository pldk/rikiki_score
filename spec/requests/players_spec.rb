# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players', type: :request do
  before { host! 'example.com' }

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
      delete player_path(player)
      expect(response).to have_http_status(:redirect)
    end
  end
end
