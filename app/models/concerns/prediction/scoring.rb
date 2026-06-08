# frozen_string_literal: true

module Prediction::Scoring # rubocop:disable Style/ClassAndModuleChildren
  extend ActiveSupport::Concern

  def calculate_score
    multiplier = is_star? ? 4 : 2
    if predicted_tricks == actual_tricks
      full_prediction_bonus? ? 10 + multiplier * 2 * predicted_tricks : 10 + multiplier * predicted_tricks
    else
      -multiplier * (predicted_tricks - actual_tricks).abs
    end
  end

  def full_prediction_bonus?
    predicted_tricks == round.length && ![round.game.rounds.minimum(:position), round.game.rounds.maximum(:position)].include?(round.position)
  end
end
