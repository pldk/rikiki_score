# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :rounds
  has_many :games, through: :rounds
end
