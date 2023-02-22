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
end
