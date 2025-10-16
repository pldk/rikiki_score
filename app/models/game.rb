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
  has_many :rounds, dependent: :destroy
  has_many :predictions, through: :rounds
  accepts_nested_attributes_for :rounds

  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players

  accepts_nested_attributes_for :players, reject_if: ->(attributes) { attributes['username'].blank? }

  # enum :mode, { short_round: 0, long_rounds: 1 }
  enum :status, { pending: 0, active: 1, finished: 2, aborted: 3 }
  enum :style, { long: 0, short: 1 }

  def total_rounds
    long? ? long_rounds : short_rounds
  end

  def long_rounds
    return 0 if players.empty?

    2 * (52 / players.size) + players.size - 2
  end

  def short_rounds
    2 * (52 / players.size) - 1
  end

  def round_count
    total_rounds.size
  end

  def generate_rounds!
    rounds.destroy_all

    total = total_rounds

    (1..total).each do |pos|
      rounds.create!(position: pos)
    end
  end
end
