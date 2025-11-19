# frozen_string_literal: true
# == Schema Information
#
# Table name: predictions
#
#  id               :integer          not null, primary key
#  predicted_tricks :integer
#  actual_tricks    :integer
#  is_star          :boolean          default(FALSE)
#  is_winner        :boolean          default(FALSE)
#  round_id         :integer          not null
#  player_id        :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  position         :integer
#
# Indexes
#
#  index_predictions_on_player_id  (player_id)
#  index_predictions_on_round_id   (round_id)
#

class Prediction < ApplicationRecord
  belongs_to :round
  belongs_to :player

  has_one :score, dependent: :destroy

  validate :only_one_star_per_phase
  validate :total_predictions_cannot_equal_round_length
  validate :total_actual_equal_round_length
  # validate :assign_last_round_star

  before_create :assign_position
  after_update :check_if_game_finished
  after_save :update_score_record

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

    errors.add(:base, "le total des annonces ne peut pas être égal à #{round.length}")
  end

  def total_actual_equal_round_length
    return unless round_id && actual_tricks
    return unless ready_for_final_actuals?

    total_actual = round.predictions.sum(:actual_tricks).to_i + actual_tricks.to_i

    errors.add(:base, "le total des annonces doit être égal à #{round.length}") if total_actual != round.length
  end

  def ready_for_final_actuals?
    filled_actuals = round.predictions.where.not(actual_tricks: nil).count
    filled_actuals == round.game.players.count - 1
  end

  def calculate_score
    multiplier = is_star? ? 4 : 2
    if predicted_tricks == actual_tricks
      full_prediction_bonus? ? 10 + multiplier * 2 * predicted_tricks : 10 + multiplier * predicted_tricks
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

  def full_prediction_bonus?
    predicted_tricks == round.length && ![round.game.rounds.minimum(:position), round.game.rounds.maximum(:position)].include?(round.position)
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

  def check_if_game_finished
    return if actual_tricks.blank?

    game = round.game
    return unless round == game.last_round

    game.check_if_finished!
  end

  # def assign_last_round_star
  #   return if is_star? # déjà défini manuellement

  #   game = round.game

  #   # Toutes les prédictions précédentes du joueur sur cette partie
  #   previous_predictions = Prediction
  #                          .joins(:round)
  #                          .where(player_id: player_id, rounds: { game_id: game.id })
  #                          .where('rounds.position < ?', round.position)

  #   # Si le joueur a déjà joué une étoile → on ne force pas
  #   return if previous_predictions.any?(&:is_star?)

  #   # Trouver les rounds extrêmes (montee et descente)
  #   last_up = game.rounds.where(phase: 'up').last
  #   last_down = game.rounds.where(phase: 'down').last

  #   is_last_up = round.length == last_up
  #   is_last_down = round.length == last_down

  #   # Si c'est l'un des derniers tours
  #   return unless is_last_up || is_last_down

  #   self.is_star = true
  # end
end
