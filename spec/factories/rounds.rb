# frozen_string_literal: true

FactoryBot.define do
  factory :round do
    length { 1 }
    game { nil }
    player { nil }
  end
end
