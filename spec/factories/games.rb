# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  stars      :boolean          default(FALSE)
#  status     :integer          default(NULL)
#  style      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :game do
    status { 1 }
    style { :long }
    stars { false }

    trait :with_players do
      transient do
        player_count { 4 }
      end

      after(:create) do |game, evaluator|
        evaluator.player_count.times do
          player = create(:player)
          create(:game_player, game: game, player: player)
        end
      end
    end
  end
end
