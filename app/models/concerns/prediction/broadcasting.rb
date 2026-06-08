# frozen_string_literal: true

module Prediction::Broadcasting # rubocop:disable Style/ClassAndModuleChildren
  extend ActiveSupport::Concern

  included do
    after_commit :broadcast_update
  end

  def broadcast_update
    broadcast_replace_to "game_#{round.game.id}_predictions",
                         target: "prediction_#{round.id}_#{player.id}",
                         partial: 'rounds/round_row',
                         locals: { round: round, player: player, prediction: self, game: round.game }
  end
end
