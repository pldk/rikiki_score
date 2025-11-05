# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Prediction, type: :model do
  let(:game) { create(:game, :with_players, player_count: 4) }
  let(:round) { create(:round, game: game, position: 4, phase: 0) }
  let(:player) { game.players.first }
  let(:prediction) { build(:prediction, round: round, player: player) }

  describe 'associations' do
    it 'belongs to a round' do
      expect(prediction.respond_to?(:round)).to be true
      expect(prediction.respond_to?(:round=)).to be true
    end

    it 'belongs to a player' do
      expect(prediction.respond_to?(:player)).to be true
      expect(prediction.respond_to?(:player=)).to be true
    end
  end

  describe 'validations' do
    it 'validates presence of score' do
      prediction.score = nil
      expect(prediction).not_to be_valid
      expect(prediction.errors[:score]).to include("can't be blank")
    end
  end

  describe '#total_predictions_cannot_equal_round_position' do
    let(:game) { create(:game, :with_players) }
    let(:round) { create(:round, game: game, length: 5) }
    let(:players) { game.players }

    it 'does not validate if total predictions equals position for last player' do
      create(:prediction, round: round, player: players[0], predicted_tricks: 1)
      create(:prediction, round: round, player: players[1], predicted_tricks: 1)
      create(:prediction, round: round, player: players[2], predicted_tricks: 2)

      last_pred = build(:prediction, round: round, player: players[3], predicted_tricks: 1)

      expect(last_pred).not_to be_valid
      expect(last_pred.errors[:predicted_tricks]).to include(/le total des annonces/)
    end

    it 'allows prediction if total is different from round length' do
      create(:prediction, round: round, player: players[0], predicted_tricks: 1)
      create(:prediction, round: round, player: players[1], predicted_tricks: 1)
      create(:prediction, round: round, player: players[2], predicted_tricks: 1)

      valid_pred = build(:prediction, round: round, player: players[3], predicted_tricks: 4)

      expect(valid_pred).to be_valid
    end
  end

  describe 'star validation' do
    let(:round) { create(:round, game: game, position: 1) }
    let(:player) { game.players.first }

    context 'when creating a star prediction' do
      it 'allows one star per phase per player' do
        prediction = create(:prediction,
                            round: round,
                            player: player,
                            predicted_tricks: 2,
                            is_star: true)

        expect(prediction).to be_valid
        expect(prediction.is_star).to be true
      end

      it 'prevents multiple stars per phase for the same player' do
        pending 'need to implement stars logic'
        create(:prediction,
               round: round,
               player: player,
               predicted_tricks: 2,
               is_star: true)

        another_round_same_phase = create(:round, game: game, position: 2)
        duplicate_star = build(:prediction,
                               round: another_round_same_phase,
                               player: player,
                               predicted_tricks: 3,
                               is_star: true)

        expect(duplicate_star).not_to be_valid
        expect(duplicate_star.errors[:is_star]).to include('déjà utilisée pour cette phase')
      end

      it 'allows star in different phases for the same player' do
        create(:prediction,
               round: round,
               player: player,
               predicted_tricks: 2,
               is_star: true)

        # Create a round in a different phase
        different_phase_round = create(:round, game: game, phase: 1)
        different_phase_star = build(:prediction,
                                     round: different_phase_round,
                                     player: player,
                                     predicted_tricks: 6,
                                     is_star: true)

        expect(different_phase_star).to be_valid
      end
    end
  end

  describe 'phase calculation' do
    let(:game) { create(:game, :with_players, player_count: 4) }
    let(:round) { create(:round, game: game, position: 3) }
    let(:prediction) { create(:prediction, round: round, player: game.players.first) }

    it 'calculates phase correctly for ascending phase' do
      # Position 3 should be in ascending phase for a game with more rounds
      expect(prediction.round.phase).to eq('up')
    end

    it 'calculates phase correctly for descending phase' do
      descending_round = create(:round, game: game, position: 15, phase: 'down')
      descending_prediction = create(:prediction, round: descending_round, player: game.players.first)

      expect(descending_prediction.round.phase).to eq('down')
    end
  end

  describe 'position assignment' do
    let(:round) { create(:round, game: game, position: 7) }
    let(:prediction) { build(:prediction, round: round, player: player) }

    it 'assigns round position before creation' do
      expect { prediction.save }
        .to change(prediction, :position)
        .from(nil).to(round.position)
    end
  end
end
