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
class Game < ApplicationRecord
  has_many :rounds, dependent: :destroy
  has_many :predictions, through: :rounds
  has_many :scores, through: :rounds

  accepts_nested_attributes_for :rounds

  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players

  accepts_nested_attributes_for :players, reject_if: ->(attributes) { attributes['username'].blank? }

  after_initialize :set_default_status, if: :new_record?

  enum :status, { pending: 0, active: 1, finished: 2, aborted: 3 }
  enum :style, { long: 0, short: 1 }

  def total_rounds
    long? ? long_rounds : short_rounds
  end

  def long_rounds
    return 0 if game_players.empty?

    2 * (52 / game_players.size) + game_players.size - 2
  end

  def short_rounds
    2 * (52 / game_players.size) - 1
  end

  def start_game!
    transaction do
      update!(status: :active)
      create_rounds_with_trump_and_phase
    end
  end

  def last_round
    rounds.find_by(phase: 'down', length: 1)
  end

  def check_if_finished!
    last = last_round
    return unless last

    if last.predictions.count == players.count &&
       last.predictions.where(actual_tricks: nil).none?
      update!(status: :finished)
    end
  end

  private

  def mid
    (total_rounds / 2.0).ceil
  end

  def half_span
    (game_players.size / 2.0).floor
  end

  def max_cards
    (52 / game_players.size).floor
  end

  def create_rounds_with_trump_and_phase
    start_no_trump = mid - half_span
    end_no_trump   = mid + half_span - 1

    transaction do
      (1..total_rounds).each do |position|
        phase = position <= mid ? :up : :down

        length = phase == :up ? [position, max_cards].min : [total_rounds - position + 1, max_cards].min

        rounds.create!(
          position: position,
          phase: phase,
          has_trump: !position.between?(start_no_trump, end_no_trump),
          length: length
        )
      end
    end
  end

  private

  def set_default_status
    self.status ||= :pending
  end
end
