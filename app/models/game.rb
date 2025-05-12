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
class Game < ApplicationRecord
  has_many :rounds
  has_many :predictions, through: :rounds

  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players

  accepts_nested_attributes_for :players, reject_if: ->(attributes) { attributes['username'].blank? }

  enum status: {
    0 => :pending,
    1 => :active,
    2 => :finished
  }

  enum style: { long: 0, short: 1 }

  def total_rounds
   long? ? long_rounds : short_rounds
  end

  def long_rounds
    2 * (52 / players.size) + players.size - 2
  end

  def short_rounds
    2 * (52 / players.size) + - 1
  end

  def round_count
    total_rounds.size
  end
end
