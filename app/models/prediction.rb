# frozen_string_literal: true

# == Schema Information
#
# Table name: predictions
#
#  id               :bigint           not null, primary key
#  actual_tricks    :integer
#  is_star          :boolean          default(FALSE)
#  is_winner        :boolean          default(FALSE)
#  predicted_tricks :integer
#  score            :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  player_id        :bigint           not null
#  round_id         :bigint           not null
#
# Indexes
#
#  index_predictions_on_player_id  (player_id)
#  index_predictions_on_round_id   (round_id)
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id)
#  fk_rails_...  (round_id => rounds.id)
#
class Prediction < ApplicationRecord
  belongs_to :round
  belongs_to :player

  has_one :score, dependent: :destroy

  validate :only_one_star_per_phase
  validate :total_predictions_cannot_equal_round_length
  validate :total_actual_equal_round_length

  before_create :assign_position

  def only_one_star_per_phase
    return unless is_star

    already_used = Prediction.joins(:round)
                             .where(player_id: player_id, is_star: true)
                             .where(rounds: { game_id: round.game.id, phase: round.phase })
                             .where.not(id: id)
                             .exists?

    errors.add(:is_star, "déjà utilisée pendant la #{round.phase == :up ? 'montée' : 'descente'}") if already_used
  end

  def total_predictions_cannot_equal_round_length
    return unless round_id && predicted_tricks

    return unless round.predictions.count == round.game.players.count - 1

    total_predicted = round.predictions.sum(:predicted_tricks) + predicted_tricks

    return unless total_predicted == round.length

    errors.add(:predicted_tricks, "le total des annonces (#{total_predicted}) ne peut pas être égal à (#{round.length})")
  end

  def total_actual_equal_round_length
    return unless round_id && actual_tricks

    return unless round.predictions.count == round.game.players.count - 1

    total_actual = round.predictions.sum(:actual_tricks) + actual_tricks

    return unless total_actual != round.length

    errors.add(:actual_tricks, "le total des annonces (#{total_actual}) doit être égal à (#{round.length})")
  end

  def calculate_score
    multiplier = is_star? ? 4 : 2

    if predicted_tricks == actual_tricks
      10 + multiplier * predicted_tricks
    else
      -multiplier * (predicted_tricks - actual_tricks).abs
    end
  end

  def self.calculate_all_scores
    all.find_each { |p| p.update!(score: p.calculate_score) }
  end

  def self.calculate_player_scores(player_id)
    where(player_id: player_id).find_each { |p| p.update!(score: p.calculate_score) }
  end

  def self.calculate_round_scores(round_id)
    where(round_id: round_id).find_each { |p| p.update!(score: p.calculate_score) }
  end

  def assign_position
    self.position = round.position
  end

  private

  def update_score_record
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
    total = 0
    game = round.game

    game.rounds.order(:position).each do |r|
      score = Score.find_by(round: r, player: player)
      next unless score

      total += score.value
      score.update!(cumulative_value: total)
    end
  end
end
