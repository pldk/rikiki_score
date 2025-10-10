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
  let(:game) { Game.new(style: 'short') }
  let(:players) { Array.new(4) { Player.create!(name: Faker::Name.first_name) } }

  it 'should not be valid without players' do
    expect(game.players).to be_empty
  end

  it 'should contain players' do
    game.save!
    game.players << players
    expect(game.players.size).to eq(4)
  end

  it 'should be a short game' do
    expect(game.style).to eq('short')
  end

  let(:long_game) { Game.new(style: 'long') }

  it 'should be a long game' do
    expect(long_game.style).to eq('long')
  end

  it 'should disable stars by default' do
    expect(game.stars).to be_falsey
  end

  it 'should enhance stars' do
    game.stars = true
    expect(game.stars).to be_truthy
  end
end
