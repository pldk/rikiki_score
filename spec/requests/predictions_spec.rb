# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Predictions', type: :request do
  let!(:game) { Game.create! }
  let!(:player) { Player.create!(name: 'Alice') }
  let!(:round) { Round.create!(phase: 1, game_id: game.id) }
  let!(:prediction) { Prediction.create(round_id: round.id, player_id: player.id, predicted_tricks: 1) }

  before { game.players << player }

  describe 'GET /edit' do
    it 'returns http success' do
      get edit_game_round_prediction_path(game, round, prediction)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      patch game_round_prediction_path(game, round, prediction), params: { prediction: { predicted_tricks: 2 } }
      expect(response).to have_http_status(:redirect)
    end
  end
end
