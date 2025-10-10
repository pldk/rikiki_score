# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'unvalid user' do
    it 'should not be valid without a name' do
      player = Player.new(name: nil)
      expect(player).not_to be_valid
    end
  end

  context 'valid user' do
    it 'should be valid with a name' do
      player = Player.new(name: 'John Doe')
      expect(player).to be_valid
    end

    it 'should have a default rank of 0' do
      player = Player.create!(name: 'John Doe')
      expect(player.rank).to eq(0)
    end

    it 'should allow setting a rank' do
      pending 'need to implement rank logic'
      player = Player.create!(name: 'John Doe', rank: 5)
      expect(player.rank).to eq(5)
    end

    it 'should allow setting a description' do
      player = Player.create!(name: 'John Doe', description: 'A great player')
      expect(player.description).to eq('A great player')
    end
  end
end
