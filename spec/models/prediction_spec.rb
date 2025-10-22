# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Prediction, type: :model do
  let(:game) { create(:game, :with_players, player_count: 4) }
  let(:round) { create(:round, game: game, position: 5) }
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
    let(:round) { create(:round, game: game, position: 5) }
    let(:players) { game.players }

    it 'does not validate if total predictions equals position for last player' do
      # 3 joueurs ont déjà fait leur prédiction
      create(:prediction, round: round, player: players[0], predicted_tricks: 1)
      create(:prediction, round: round, player: players[1], predicted_tricks: 1)
      create(:prediction, round: round, player: players[2], predicted_tricks: 2)

      # Dernier joueur entre sa prédiction
      last_pred = build(:prediction, round: round, player: players[3], predicted_tricks: 1)

      expect(last_pred).not_to be_valid
      expect(last_pred.errors[:predicted_tricks]).to include(/le total des prédictions/)
    end

    it 'allows prediction if total is different from round position' do
      create(:prediction, round: round, player: players[0], predicted_tricks: 1)
      create(:prediction, round: round, player: players[1], predicted_tricks: 1)
      create(:prediction, round: round, player: players[2], predicted_tricks: 1)

      valid_pred = build(:prediction, round: round, player: players[3], predicted_tricks: 3)

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

        # Try to create another star prediction for the same player in the same phase
        # For a 4-player game, positions 1-2 would be ascending phase, 3+ would be descending
        another_round_same_phase = create(:round, game: game, position: 2) # Same phase (ascending)
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
        different_phase_round = create(:round, game: game, position: 3) # Different phase (descending)
        different_phase_star = build(:prediction,
                                     round: different_phase_round,
                                     player: player,
                                     predicted_tricks: 2,
                                     is_star: true)

        expect(different_phase_star).to be_valid
      end
    end
  end

  describe 'score calculation' do
    let(:prediction) { create(:prediction, predicted_tricks: 3, actual_tricks: 3) }

    context 'when prediction is correct' do
      it 'calculates score correctly for non-star prediction' do
        prediction.update(is_star: false)
        score = prediction.calculate_score

        # 10 + 2 * 3 = 16
        expect(score).to eq(16)
      end

      it 'calculates score correctly for star prediction' do
        prediction.update(is_star: true)
        score = prediction.calculate_score

        # 10 + 4 * 3 = 22
        expect(score).to eq(22)
      end
    end

    context 'when prediction is incorrect' do
      let(:prediction) { create(:prediction, predicted_tricks: 3, actual_tricks: 1) }

      it 'calculates negative score for non-star prediction' do
        prediction.update(is_star: false)
        score = prediction.calculate_score

        # -2 * |3 - 1| = -4
        expect(score).to eq(-4)
      end

      it 'calculates negative score for star prediction' do
        prediction.update(is_star: true)
        score = prediction.calculate_score

        # -4 * |3 - 1| = -8
        expect(score).to eq(-8)
      end
    end
  end

  describe 'class methods' do
    let!(:game) { create(:game, :with_players, player_count: 3) }
    let!(:round) { create(:round, game: game) }
    let!(:players) { game.players }

    before do
      players.each do |player|
        create(:prediction, round: round, player: player, predicted_tricks: 2, actual_tricks: 2)
      end
    end

    describe '.calculate_all_scores' do
      it 'calculates scores for all predictions' do
        expect { described_class.calculate_all_scores }
          .to(change { described_class.pluck(:score) })
      end
    end

    describe '.calculate_player_scores' do
      it 'calculates scores for specific player' do
        player = players.first
        expect { described_class.calculate_player_scores(player.id) }
          .to(change { player.predictions.pluck(:score) })
      end
    end

    describe '.calculate_round_scores' do
      it 'calculates scores for specific round' do
        expect { described_class.calculate_round_scores(round.id) }
          .to(change { round.predictions.pluck(:score) })
      end
    end
  end

  describe 'phase calculation' do
    let(:game) { create(:game, :with_players, player_count: 4) }
    let(:round) { create(:round, game: game, position: 3) }
    let(:prediction) { create(:prediction, round: round, player: game.players.first) }

    it 'calculates phase correctly for ascending phase' do
      # Position 3 should be in ascending phase for a game with more rounds
      expect(prediction.phase).to eq(:up)
    end

    it 'calculates phase correctly for descending phase' do
      descending_round = create(:round, game: game, position: 15)
      descending_prediction = create(:prediction, round: descending_round, player: game.players.first)

      expect(descending_prediction.phase).to eq(:down)
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
