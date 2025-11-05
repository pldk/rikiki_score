# frozen_string_literal: true

FactoryBot.define do
  factory :score do
    value { 1 }
    cumulative_value { 1 }
    association :prediction
    association :player
    association :round
  end
end
