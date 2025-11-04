# frozen_string_literal: true

# == Schema Information
#
# Table name: rounds
#
#  id         :bigint           not null, primary key
#  has_trump  :boolean          default(TRUE)
#  length     :integer
#  phase      :integer          default(0)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_rounds_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#
require 'rails_helper'

RSpec.describe Round, type: :model do
  let(:game) { create(:game, :with_players, player_count: 4) }
  let(:round) { create(:round, game: game, position: 5) }
  let(:player) { game.players.first }
  let(:prediction) { build(:prediction, round: round, player: player) }

  describe 'game phases and trump logic' do
    context 'ascending game (phase up)' do
      let(:game) { create(:game, :with_players, player_count: 4, style: :long) }

      before do
        game.start_game!
      end

      it "has phase 'up' for rounds in ascending phase" do
        ascending_rounds = game.rounds.where(phase: :up)
        expect(ascending_rounds.count).to be > 0

        ascending_rounds.each do |round|
          expect(round.phase).to eq('up')
          expect(round.position).to be <= (game.total_rounds / 2.0).ceil
        end
      end

      it 'has has_trump false at the last round of ascending phase' do
        mid_point = (game.total_rounds / 2.0).ceil
        last_ascending_round = game.rounds.find_by(position: mid_point)

        expect(last_ascending_round).to be_present
        expect(last_ascending_round.phase).to eq('up')
        expect(last_ascending_round.has_trump).to be false
      end

      it 'has has_trump true for most rounds in ascending phase' do
        ascending_rounds = game.rounds.where(phase: :up)
        trump_rounds = ascending_rounds.where(has_trump: true)

        # Most rounds in ascending phase should have trump
        expect(trump_rounds.count).to be > (ascending_rounds.count / 2)
      end
    end

    context 'descending phase' do
      let(:game) { create(:game, :with_players, player_count: 4, style: :long) }

      before do
        game.start_game!
      end

      it "has phase 'down' for rounds in descending phase" do
        descending_rounds = game.rounds.where(phase: :down)
        expect(descending_rounds.count).to be > 0

        descending_rounds.each do |round|
          expect(round.phase).to eq('down')
          expect(round.position).to be > (game.total_rounds / 2.0).ceil
        end
      end

      it 'has has_trump false for rounds in the middle section' do
        mid_point = (game.total_rounds / 2.0).ceil
        half_span = (game.players.size / 2.0).floor
        start_no_trump = mid_point - half_span
        end_no_trump = mid_point + half_span - 1

        no_trump_rounds = game.rounds.where(position: start_no_trump..end_no_trump)

        no_trump_rounds.each do |round|
          expect(round.has_trump).to be false
        end
      end
    end

    context 'edge cases and transitions' do
      let(:game) { create(:game, :with_players, player_count: 4, style: :long) }

      before do
        game.start_game!
      end

      it 'has correct phase transition at midpoint' do
        mid_point = (game.total_rounds / 2.0).ceil

        last_up_round = game.rounds.find_by(position: mid_point)
        first_down_round = game.rounds.find_by(position: mid_point + 1)

        expect(last_up_round.phase).to eq('up')
        expect(first_down_round.phase).to eq('down')
      end

      it 'has correct length calculation for ascending rounds' do
        max_cards = (52 / game.players.size).floor
        ascending_rounds = game.rounds.where(phase: :up)

        ascending_rounds.each do |round|
          expected_length = [round.position, max_cards].min
          expect(round.length).to eq(expected_length)
        end
      end

      it 'has correct length calculation for descending rounds' do
        max_cards = (52 / game.players.size).floor
        descending_rounds = game.rounds.where(phase: :down)

        descending_rounds.each do |round|
          expected_length = [game.total_rounds - round.position + 1, max_cards].min
          expect(round.length).to eq(expected_length)
        end
      end
    end

    context 'short game style' do
      let(:game) { create(:game, :with_players, player_count: 4, style: :short) }

      before do
        game.start_game!
      end

      it 'has correct total rounds for short game' do
        expect(game.rounds.count).to eq(game.short_rounds)
      end

      it 'stills follow ascending/descending phase logic' do
        mid_point = (game.total_rounds / 2.0).ceil

        ascending_rounds = game.rounds.where(phase: :up)
        descending_rounds = game.rounds.where(phase: :down)

        expect(ascending_rounds.count).to eq(mid_point)
        expect(descending_rounds.count).to eq(game.total_rounds - mid_point)
      end
    end
  end
end
