# frozen_string_literal: true

# == Schema Information
#
# Table name: game_players
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  player_id  :bigint           not null
#
# Indexes
#
#  index_game_players_on_game_id    (game_id)
#  index_game_players_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (player_id => players.id)
#
FactoryBot.define do
  factory :game_player do
    game { nil }
    player { nil }
  end
end
