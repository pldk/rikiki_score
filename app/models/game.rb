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
class Game < ApplicationRecord
  has_many :rounds
  has_many :players, through: :rounds
  accepts_nested_attributes_for :players, reject_if: ->(attributes){ attributes['username'].blank? }

  enum status: {
    active: 0,
    closed: 1
  }

  enum style: %w[long short]
  enum stars: %w[true false]
end
