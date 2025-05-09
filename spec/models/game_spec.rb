# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  stars      :boolean          default(FALSE)
#  status     :integer          default("active")
#  style      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.new(style: 'short') }
  it 'should not be valid without players' do
    expect(game.players).to be_empty
  end
  let(:players) { Array.new(4) { Player.new } }
  it 'should contain players' do
    game.players = players
    expect(game.players.size).to eq(4)
  end

  it 'should be a short game' do
    expect(game.style).to be('short')
  end

  it 'should be a long game' do
    game.update(style: 'long')
    expect(game.style).to be('long')
  end

  it 'should disable stars' do
    expect(game.stars).to be_falsey
  end

  it 'should enhance stars' do
    game.stars = 0
    expect(game.stars).to be_truthy
  end
end
