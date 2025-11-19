# frozen_string_literal: true

# == Schema Information
#
# Table name: predictions
#
#  id               :integer          not null, primary key
#  predicted_tricks :integer
#  actual_tricks    :integer
#  is_star          :boolean          default(FALSE)
#  is_winner        :boolean          default(FALSE)
#  round_id         :integer          not null
#  player_id        :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  position         :integer
#
# Indexes
#
#  index_predictions_on_player_id  (player_id)
#  index_predictions_on_round_id   (round_id)
#

FactoryBot.define do
  factory :prediction do
    predicted_tricks { 1 }
    # actual_tricks { 1 }
    is_star { false }
    is_winner { false }
    association :round
    association :player
  end
end
