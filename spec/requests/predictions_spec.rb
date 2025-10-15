# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Predictions', type: :request do
  let!(:game) { Game.create! }
  let!(:player) { Player.create!(name: 'Alice') }
  let!(:round) { Round.create!(phase: 1, game: game, position: 5) }
  let!(:prediction) { Prediction.create(round: round, player: player, predicted_tricks: 1) }

  before { game.players << player }

  describe 'PATCH /update predicted_tricks' do
    it 'updates the predicted_tricks and redirects' do
      patch game_round_prediction_path(game, round, prediction), 
            params: { prediction: { predicted_tricks: 2 } }
      expect(response).to have_http_status(:success)
      expect(prediction.reload.predicted_tricks).to eq(2)
    end
  end

  describe 'PATCH /update actual_tricks' do
    it 'updates the actual_tricks and redirects' do
      patch game_round_prediction_path(game, round, prediction), 
            params: { prediction: { actual_tricks: 1 } }
      expect(response).to have_http_status(:success)
      expect(prediction.reload.actual_tricks).to eq(1)
    end
  end
end
