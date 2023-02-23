# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :rounds
  has_many :players, through: :rounds

  enum status: {
    active: 0,
    closed: 1
  }

  enum style: %w[long short]
  # enum stars_enhanced: %w[true false]

  def long_rounds
    52 / players.size * 2 - 1 + players.size - 1
  end

  def short_rounds
    52 / players.size * 2 - 1
  end
end
