# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  stars      :boolean          default(NULL)
#  status     :integer
#  style      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :game do
    status { 1 }
  end
end
