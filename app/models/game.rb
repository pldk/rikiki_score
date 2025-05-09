# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  stars      :boolean          default(FALSE)
#  status     :integer          default("active")
#  style      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Game < ApplicationRecord
  has_many :rounds
  has_many :predictions, through: :rounds
  has_many :players
  accepts_nested_attributes_for :players, reject_if: ->(attributes) { attributes['username'].blank? }

  enum status: {
    active: 0,
    closed: 1
  }

  enum style: { long: 0, short: 1 }
end
