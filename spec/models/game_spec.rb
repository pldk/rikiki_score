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

  it 'is not valid without players' do
    expect(game.players).to be_empty
  end

  it 'contains players' do
    game.save!
    game.players << players
    expect(game.players.size).to eq(4)
  end

  it 'is a short game' do
    expect(game.style).to eq('short')
  end

  it 'is a long game' do
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
