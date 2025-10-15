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
    it 'is not valid without a name' do
      player = described_class.new(name: nil)
      expect(player).not_to be_valid
    end
  end

  context 'valid user' do
    it 'is valid with a name' do
      player = described_class.new(name: 'John Doe')
      expect(player).to be_valid
    end

    it 'has a default rank of 0' do
      player = described_class.create!(name: 'John Doe')
      expect(player.rank).to eq(0)
    end

    it 'allows setting a rank' do
      pending 'need to implement rank logic'
      player = described_class.create!(name: 'John Doe', rank: 5)
      expect(player.rank).to eq(5)
    end

    it 'allows setting a description' do
      player = described_class.create!(name: 'John Doe', description: 'A great player')
      expect(player.description).to eq('A great player')
    end
  end
end
