# frozen_string_literal: true

module Prediction::CumulativeScores # rubocop:disable Style/ClassAndModuleChildren
  extend ActiveSupport::Concern

  included do
    after_commit :update_score_record
  end

  private

  def update_score_record
    return if actual_tricks.blank?

    score_value = calculate_score
    score_record = Score.find_or_initialize_by(prediction: self)
    score_record.assign_attributes(
      player: player,
      round: round,
      value: score_value
    )
    score_record.save!
    update_cumulative_for_game
  end

  def update_cumulative_for_game
    previous_total = previous_cumulative_total
    score_record = current_score_record
    score_record.update!(cumulative_value: previous_total + score_record.value)
    update_future_cumulatives(score_record.cumulative_value)
  end

  def previous_cumulative_total
    previous_round = round.game.rounds.where('position < ?', round.position).order(:position).last
    return 0 unless previous_round

    previous_score = previous_round.scores.find_by(player: player)
    previous_score&.cumulative_value || 0
  end

  def current_score_record
    score || Score.find_by(prediction: self)
  end

  def update_future_cumulatives(previous_total)
    round.game.rounds.where('position > ?', round.position).order(:position).each do |r|
      next_score = Score.find_by(round: r, player: player)
      next unless next_score

      previous_total += next_score.value
      next_score.update!(cumulative_value: previous_total)
    end
  end
end
