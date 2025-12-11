# frozen_string_literal: true

module GamesHelper
  def dealer_for_round(game, round)
    game.players[(round.position - 1) % game.players.size]
  end

  def winner?(player, winner)
    player == winner
  end

  def winner_column_classes(player, winner)
    return '' unless winner?(player, winner)

    'bg-yellow-100 dark:bg-yellow-900/40 font-bold text-yellow-700 dark:text-yellow-300'
  end
end
