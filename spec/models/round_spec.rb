# frozen_string_literal: true

# == Schema Information
#
# Table name: rounds
#
#  id         :bigint           not null, primary key
#  length     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  player_id  :bigint           not null
#
# Indexes
#
#  index_rounds_on_game_id    (game_id)
#  index_rounds_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (player_id => players.id)
#
require 'rails_helper'

RSpec.describe Round, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
