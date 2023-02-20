# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :game
  belongs_to :player
end
