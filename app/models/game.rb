class Game < ApplicationRecord
  has_many :rounds
  has_many :players, through: :rounds  

  enum status: %w(active closed)
  # enum styles: %w(long short)
  # enum stars_enhanced: [true, false]
end
