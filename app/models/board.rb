class Board < ApplicationRecord
  serialize :grid, Array

  def self.create_board
    Board.create!(grid: Array.new(9) { ' ' })
  end

  def set_cell(position, value)
    return false if invalid_position?(position) || position_taken?(position)

    self[:grid][position - 1] = value
    save
    true
  end

  def draw?
    self[:grid].none? { |cell| cell == ' ' }
  end

  def winner?
    grid = self[:grid]
    win_combinations.each do |win_combination|
      next if win_combination.all? { |combination_value| grid[combination_value] == ' ' }
      return true if win_combination.all? { |combination_value| grid[combination_value] == grid[win_combination[0]] }
    end
    false
  end

  def self.get(board_id)
    Board.where(id: board_id).take
  end

  private

  def invalid_position?(position)
    !position.to_i.between?(1, 9)
  end

  def position_taken?(position)
    return false if self[:grid][position.to_i - 1] == ' '

    true
  end

  def win_combinations
    [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ]
  end
end
