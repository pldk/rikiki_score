# frozen_string_literal: true

module GamesHelper
  def dealer_for_round(game, round)
    game.players[(round.position - 1) % game.players.size]
  end
end
