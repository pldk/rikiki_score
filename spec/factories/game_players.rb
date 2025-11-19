# frozen_string_literal: true

# == Schema Information
#
# Table name: game_players
#
#  id         :integer          not null, primary key
#  game_id    :integer          not null
#  player_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#
# Indexes
#
#  index_game_players_on_game_id    (game_id)
#  index_game_players_on_player_id  (player_id)
#

FactoryBot.define do
  factory :game_player do
    association :game
    association :player
  end
end
