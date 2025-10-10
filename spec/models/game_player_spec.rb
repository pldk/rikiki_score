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
#
# Indexes
#
#  index_game_players_on_game_id    (game_id)
#  index_game_players_on_player_id  (player_id)
#

require 'rails_helper'

RSpec.describe GamePlayer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
