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

FactoryBot.define do
  factory :round do
    length { 1 }
    position { 1 }
    has_trump { true }
    phase { 0 }
    association :game
  end
end
