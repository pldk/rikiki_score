# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Prediction and Score integration', type: :model do
  let!(:game)   { create(:game, :with_players, player_count: 4) }
  let!(:player) { Player.create!(name: 'Alice') }
  let!(:first_round) { Round.create!(game: game, position: 1, length: 5, phase: 1) }
  let!(:second_round) { Round.create!(game: game, position: 2, length: 5, phase: 1) }
  let!(:prediction) { Prediction.create!(round: first_round, player: player, predicted_tricks: 2) }

  before do
    game.players << player
  end

  describe 'Score creation' do
    it 'creates a score automatically when a prediction is saved' do
      prediction.update(actual_tricks: 2)

      expect(prediction.score).to be_present
      expect(prediction.score.value).to eq(prediction.calculate_score)
      expect(prediction.score.round).to eq(first_round)
      expect(prediction.score.player).to eq(player)
    end
  end

  describe 'Score calculation' do
    it 'calculates correct score for a correct prediction' do
      prediction.update(actual_tricks: 2, is_star: false)
      expect(prediction.score.value).to eq(14)
    end

    it 'calculates correct score for an incorrect prediction' do
      prediction.update(actual_tricks: 3, is_star: false)
      expect(prediction.score.value).to eq(-2)
    end

    it 'applies multiplier if is_star is true' do
      prediction.update(actual_tricks: 2, is_star: true)
      expect(prediction.score.value).to eq(18)
    end
  end

  describe 'Cumulative score' do
    it 'updates cumulative_value across multiple rounds' do
      p1 = Prediction.find_by(round: first_round, player: player)
      p1.update!(predicted_tricks: 2, actual_tricks: 2)

      p2 = Prediction.create(round: second_round, player: player)
      p2.update!(predicted_tricks: 1, actual_tricks: 1)

      expect(p1.score.cumulative_value).to eq(p1.score.value)
      expect(p2.score.cumulative_value).to eq(p1.score.cumulative_value + p2.score.value)
    end
  end
end
