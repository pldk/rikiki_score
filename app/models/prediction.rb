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

  # validates :predicted_tricks, presence: truetot
  # validates :actual_trickstot
  validates :score, presence: true

  validate :only_one_star_per_phase

  before_create :assign_position

  def only_one_star_per_phase
    return unless is_star

    current_phase = round.phase
    existing_star = Prediction
                    .joins(:round)
                    .where(player_id: player_id, is_star: true)
                    .where(rounds: { phase: current_phase })
                    .where.not(id: id)
                    .exists?

    return unless existing_star

    errors.add(:is_star, 'déjà utilisée pour cette phase')
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
    all.each(&:calculate_score)
  end

  def self.calculate_player_scores(player_id)
    where(player_id: player_id).each(&:calculate_score)
  end

  def self.calculate_round_scores(round_id)
    where(round_id: round_id).each(&:calculate_score)
  end

  def assign_position
    round.position
  end

  def phase
    total_rounds = game.total_rounds
    midpoint = (total_rounds / 2.0).floor
    position < midpoint ? 'ascending' : 'descending'
  end
end
