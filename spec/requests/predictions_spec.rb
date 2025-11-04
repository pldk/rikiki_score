# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Predictions', type: :request do
  let!(:game) { Game.create! }
  let!(:player_1) { Player.create!(name: 'Alice') }
  let!(:player_2) { Player.create!(name: 'Bob') }
  let!(:round) { Round.create!(phase: 1, game: game, position: 5, length: 5) }
  let!(:prediction_1) { Prediction.create!(round: round, player: player_1, predicted_tricks: 2) }
  let!(:prediction_2) { Prediction.create!(round: round, player: player_2, predicted_tricks: 3) }

  before { game.players << player_1 << player_2 }

  context 'when the prediction is valid' do
    describe 'POST /predictions#create' do
      it 'creates the predicted_tricks and redirects' do
        post game_round_predictions_path(game, round), params: { prediction: { predicted_tricks: 2, player_id: player_1.id } }
        expect(response).to have_http_status(:redirect)
        expect(prediction_1.reload.predicted_tricks).to eq(2)
      end
    end

    describe 'PATCH /update actual_tricks' do
      it 'updates actual_tricks and redirects' do
        patch game_round_prediction_path(game, round, prediction_1),
              params: { prediction: { actual_tricks: 1 } }

        expect(response).to have_http_status(:redirect)
        expect(prediction_1.reload.actual_tricks).to eq(1)
      end
    end
  end
end
