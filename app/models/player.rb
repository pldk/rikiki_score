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

  has_many :predictions
  has_many :rounds, through: :predictions

  has_many :game_players, dependent: :destroy
  has_many :games, through: :game_players

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
end
