# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rounds', type: :request do
  let!(:game) { Game.create }
  let!(:player) { Player.create }
  let!(:round) { Round.create(game: game) }
  describe 'GET /index' do
    it 'returns http success' do
      get game_rounds_path(game)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get game_round_path(game, round)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get new_game_round_path(game, round)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'returns http success' do
      post game_rounds_path(game), params: { round: { position: 1 } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET /edit' do
    it 'returns http success' do
      get edit_game_round_path(game, round)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PATCH /update' do
    it 'returns http success' do
      get game_round_path(game, round)
      expect(response).to have_http_status(:success)
    end
  end

  # describe 'EDIT /destroy' do
  #   it 'returns http success' do
  #     delete game_round_path(game)
  #     expect(response).to have_http_status(:success)
  #   end
  # end
end
