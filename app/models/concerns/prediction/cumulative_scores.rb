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
    broadcast_leader_cells_if_complete
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

  def broadcast_leader_cells_if_complete
    game = round.game
    total_players = game.players.count

    return unless round.predictions.where.not(actual_tricks: nil).count == total_players

    completed = game.rounds
      .joins(:predictions)
      .group('rounds.id')
      .having('COUNT(CASE WHEN predictions.actual_tricks IS NOT NULL THEN 1 END) = ?', total_players)
      .order('rounds.position DESC')
      .limit(2)
      .to_a

    return if completed.empty?

    last_completed = Round.includes(:predictions).find(completed[0].id)
    prev_completed = completed[1] ? Round.includes(:predictions).find(completed[1].id) : nil
    leaders = last_completed.leaders

    game.players.each do |player|
      broadcast_replace_to(
        "game_#{game.id}_predictions",
        target: "prediction_#{last_completed.id}_#{player.id}",
        partial: 'rounds/round_row',
        locals: {
          round: last_completed,
          player: player,
          prediction: last_completed.predictions.find { |p| p.player_id == player.id },
          game: game,
          is_leader: leaders.include?(player)
        }
      )
    end

    if prev_completed
      game.players.each do |player|
        broadcast_replace_to(
          "game_#{game.id}_predictions",
          target: "prediction_#{prev_completed.id}_#{player.id}",
          partial: 'rounds/round_row',
          locals: {
            round: prev_completed,
            player: player,
            prediction: prev_completed.predictions.find { |p| p.player_id == player.id },
            game: game,
            is_leader: false
          }
        )
      end
    end

    broadcast_refresh_to("game_#{game.id}_predictions")
  end
end
