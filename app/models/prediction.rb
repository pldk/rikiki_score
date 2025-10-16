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

  validates :score, presence: true
  validate :only_one_star_per_phase
  validate :total_predictions_cannot_equal_round_position

  before_create :assign_position

  delegate :phase, to: :round

  # enum :phase, { up: 0, down: 1 }

  # attribute :phase

  def only_one_star_per_phase
    return unless is_star

    already_used = Prediction.joins(:round)
                             .where(player_id: player_id, is_star: true)
                             .where(rounds: { game_id: round.game.id, phase: round.phase })
                             .where.not(id: id)
                             .exists?

    errors.add(:is_star, "déjà utilisée pendant la #{phase == :up ? 'montée' : 'descente'}") if already_used
  end

  def total_predictions_cannot_equal_round_position
    return unless round_id && predicted_tricks

    # Get all predictions for this round (including the current one being saved)
    existing_predictions = round.predictions.where.not(id: id)
    total_predicted = existing_predictions.sum(:predicted_tricks) + predicted_tricks

    return unless total_predicted == round.position

    errors.add(:predicted_tricks, "le total des prédictions (#{total_predicted}) ne peut pas être égal à (#{round.position})")
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
end
