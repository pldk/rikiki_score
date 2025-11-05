# frozen_string_literal: true

# == Schema Information
#
# Table name: rounds
#
#  id         :bigint           not null, primary key
#  has_trump  :boolean          default(TRUE)
#  length     :integer
#  phase      :integer          default(0)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_rounds_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#
class Round < ApplicationRecord
  belongs_to :game
  has_many :predictions, dependent: :destroy
  has_many :players, through: :predictions
  has_many :scores, dependent: :destroy

  accepts_nested_attributes_for :predictions

  enum :phase, { up: 0, down: 1 }
end
