# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  rank        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Player < ApplicationRecord
  after_update_commit :capitalize_name

  has_many :predictions, dependent: :destroy
  has_many :rounds, through: :predictions
  has_many :scores, through: :predictions

  has_many :game_players, dependent: :destroy
  has_many :games, through: :game_players

  has_many :scores, dependent: :destroy

  validates :name, presence: true

  def games_played
    games.size
  end

  def rank
    games.size
  end

  def games_won
    games.size
  end

  def capitalize_name
    name.capitalize if name.present?
  end

  def total_score_for(game)
    scores.joins(:round).where(rounds: { game_id: game.id }).sum(:value)
  end

  def cumulative_scores
    scores = {}
    total = 0
    predictions.joins(:round).order('rounds.position ASC').each do |prediction|
      total += prediction.score || 0
      scores[prediction.round_id] = total
    end
    scores
  end
end
