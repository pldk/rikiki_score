# frozen_string_literal: true

class Score < ApplicationRecord
  belongs_to :prediction
  belongs_to :player
  belongs_to :round
  has_one :game, through: :round

  validates :value, presence: true

  scope :for_game, ->(game) { joins(:round).where(rounds: { game_id: game.id }) }
  scope :for_player, ->(player) { where(player: player) }
end
