# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :rounds
  has_many :players, through: :rounds
  # accepts_nested_attributes_for :players, reject_if: ->(attributes){ attributes['username'].blank? }

  enum status: {
    active: 0,
    closed: 1
  }

  enum style: %w[long short]
  enum stars: %w[true false]
end
