# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { Game.new } 
  it 'should not be valid without players' do
    expect(game.players).to be_empty
  end
  let(:players) { Array.new(3) { Player.new } }
  it 'should contain players' do
    game.players = players
    expect(game.players.size).to eq (3)
  end
end
