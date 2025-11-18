# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Prediction and Score integration', type: :model do
  let!(:game) { create(:game, :with_players, player_count: 4) }
  let!(:player) { game.players.first }
  let!(:first_round) { Round.create!(game: game, position: 1, length: 3, phase: 1) }
  let!(:middle_round) { Round.create!(game: game, position: 2, length: 3, phase: 1) }
  let!(:last_round) { create(:round, game: game, position: 3, length: 3) }

  before do
    game.players << player
  end

  describe 'Score creation' do
    it 'creates a score automatically when a prediction is saved' do
      prediction = Prediction.create!(round: first_round, player: player, predicted_tricks: 2, actual_tricks: 2)

      expect(prediction.score).to be_present
      expect(prediction.score.value).to eq(prediction.calculate_score)
      expect(prediction.score.round).to eq(first_round)
      expect(prediction.score.player).to eq(player)
    end
  end

  describe 'Score calculation' do
    context 'without star' do
      it 'calculates normal score when prediction matches actual_tricks' do
        prediction = Prediction.new(round: middle_round, player: player, predicted_tricks: 2, actual_tricks: 2, is_star: false)
        expect(prediction.calculate_score).to eq(10 + 2 * 2) # 10 + multiplier*predicted_tricks
      end

      it 'applies full prediction bonus in middle rounds' do
        prediction = Prediction.new(round: middle_round, player: player, predicted_tricks: 3, actual_tricks: 3, is_star: false)
        expect(prediction.calculate_score).to eq(10 + 2 * 2 * 3) # 10 + multiplier*2*predicted_tricks
      end

      it 'does not apply full prediction bonus on first or last round' do
        first = Prediction.new(round: first_round, player: player, predicted_tricks: 3, actual_tricks: 3, is_star: false)
        last  = Prediction.new(round: last_round,  player: player, predicted_tricks: 3, actual_tricks: 3, is_star: false)
        expect(first.calculate_score).to eq(10 + 2 * 3)
        expect(last.calculate_score).to eq(10 + 2 * 3)
      end

      it 'applies normal penalty when prediction fails' do
        prediction = Prediction.new(round: middle_round, player: player, predicted_tricks: 2, actual_tricks: 0, is_star: false)
        expect(prediction.calculate_score).to eq(-2 * (2 - 0)) # -multiplier * diff
      end
    end

    context 'with star' do
      it 'applies x4 multiplier for success' do
        prediction = Prediction.new(round: middle_round, player: player, predicted_tricks: 2, actual_tricks: 2, is_star: true)
        expect(prediction.calculate_score).to eq(10 + 4 * 2) # multiplier x4
      end

      it 'applies star bonus + full prediction bonus if full predicted' do
        prediction = Prediction.new(round: middle_round, player: player, predicted_tricks: 3, actual_tricks: 3, is_star: true)
        expect(prediction.calculate_score).to eq(10 + 4 * 2 * 3) # multiplier x4 *2
      end

      it 'applies normal penalty on failure even with star' do
        prediction = Prediction.new(round: middle_round, player: player, predicted_tricks: 3, actual_tricks: 1, is_star: true)
        expect(prediction.calculate_score).to eq(-4 * (3 - 1)) # multiplier x4
      end
    end
  end

  describe 'Cumulative score' do
    it 'updates cumulative_value across multiple rounds' do
      p1 = Prediction.create!(round: first_round, player: player, predicted_tricks: 2)
      p1.update!(actual_tricks: 2)

      p2 = Prediction.create!(round: middle_round, player: player, predicted_tricks: 1)
      p2.update!(actual_tricks: 1)

      expect(p1.score.cumulative_value).to eq(p1.score.value)
      expect(p2.score.cumulative_value).to eq(p1.score.cumulative_value + p2.score.value)
    end
  end
end
