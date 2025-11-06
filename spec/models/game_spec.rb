# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  stars      :boolean          default(FALSE)
#  status     :integer          default(NULL)
#  style      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { described_class.new(style: 'short') }
  let(:players) { Array.new(4) { Player.create!(name: Faker::Name.first_name) } }

  let(:long_game) { described_class.new(style: 'long') }

  describe 'A game is not valid' do
    it 'without players' do
      expect(game.players).to be_empty
    end
  end

  describe 'A game is valid' do
    it 'with players' do
      game.save!
      game.players << players
      expect(game.players.size).to eq(4)
    end
  end

  describe 'The different game behaviours' do
    it 'a short game' do
      expect(game.style).to eq('short')
    end

    it 'a long game' do
      expect(long_game.style).to eq('long')
    end

    it 'disables stars by default' do
      expect(game.stars).to be_falsey
    end

    it 'enhances stars' do
      game.stars = true
      expect(game.stars).to be_truthy
    end
  end

  describe 'Game finishing logic' do
    it 'marks the game as finished when all actual_tricks are filled in the last round' do
      game = create(:game)
      last_round = create(:round, game: game, phase: 'down', length: 1)
      players = create_list(:player, 3)
      players.each do |p|
        game.players << p
        Prediction.new(round: last_round, player: p, predicted_tricks: 1).save(validate: false)
      end

      expect(game.reload.status).to eq('active')

      # on remplit les actual_tricks
      last_round.predictions.update_all(actual_tricks: 1)

      last_round.predictions.each(&:reload)
      last_round.predictions.last.send(:check_if_game_finished)

      expect(game.reload.status).to eq('finished')
    end
  end
end
