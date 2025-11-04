# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Predictions', type: :request do
  let!(:game) { Game.create! }
  let!(:player) { Player.create!(name: 'Alice') }
  let!(:round) { Round.create!(phase: 1, game: game, position: 5, length: 5) }
  let!(:prediction) { Prediction.create!(round: round, player: player, predicted_tricks: 2) }

  before { game.players << player_1 << player_2 }

  context 'when the prediction is valid' do
    describe 'POST /predictions#create' do
      it 'creates the predicted_tricks and redirects' do
        post game_round_predictions_path(game, round), params: { prediction: { predicted_tricks: 2, player_id: player.id } }
        expect(response).to have_http_status(:redirect)
        expect(prediction.reload.predicted_tricks).to eq(2)
      end
    end

    describe 'PATCH /update actual_tricks' do
      it 'updates actual_tricks and redirects' do
        patch game_round_prediction_path(game, round, prediction),
              params: { prediction: { actual_tricks: 5 } }

        expect(response).to have_http_status(:redirect)
        expect(prediction.reload.actual_tricks).to eq(5)
      end
    end
  end
end
