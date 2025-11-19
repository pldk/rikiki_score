# frozen_string_literal: true
# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  length     :integer
#  position   :integer
#  game_id    :integer          not null
#  has_trump  :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  phase      :integer
#
# Indexes
#
#  index_rounds_on_game_id  (game_id)
#

class Round < ApplicationRecord
  belongs_to :game
  has_many :predictions, dependent: :destroy
  has_many :players, through: :predictions
  has_many :scores, dependent: :destroy

  accepts_nested_attributes_for :predictions

  enum :phase, { up: 0, down: 1 }
end
