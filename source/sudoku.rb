class Sudoku
<<<<<<< HEAD
  def initialize board_string
    @board = []
    board_string.split('').each_with_index do |cell_value, index|
      @board << Cell.new(index, cell_value.to_i)
    end

  end

  def solve!
    while @board.any? { |cell| cell.empty? }
      @changed = false

      refresh_possible_values

      single_value_elimination
      9.times do |index|
        row = @board.select { |selected_cell| selected_cell.row == index + 1 }
        group_elimination row

        column = @board.select { |selected_cell| selected_cell.column == index + 1 }
        group_elimination column

        box = @board.select { |selected_cell| selected_cell.box == index + 1 }
        group_elimination box
      end
      return false if is_any_cell_impossible?
      return guess if @changed == false
    end
    return true
  end

  def guess
    #each amount of possible values
    refresh_possible_values
    board_save = Marshal.dump(@board)
    (2..9).each do |amount_of_possible_values|
      selected_cells = @board.select { |cell| cell.possible_values.length == amount_of_possible_values}
      selected_cells.shuffle.each do |selected_cell|
        selected_cell.possible_values.each do |possible_value|
          @board[selected_cell.index].value = possible_value
          @board[selected_cell.index].possible_values = []
          return true if solve!
          @board = Marshal.load(board_save)
        end
      end
    end
    false
  end


  ##################
  #  Eliminations  #
  ##################
  def single_value_elimination
    @board.map! do |selected_cell|
      if selected_cell.possible_values.length == 1
        @changed = true
        selected_cell.value = selected_cell.possible_values[0]
        selected_cell.possible_values = []
      end
      selected_cell
    end
  end

  def group_elimination group
    possible = (1..9).to_a
    group.each do |cell|
      possible.delete(cell.value)
    end

    possible.each do |possible_value|
      available_cells = group.select { |cell| cell.possible_values.include?(possible_value) }
      # require 'debugger';debugger if possible_value == 4
      if available_cells.length == 1
        @changed = true
        available_cells.first.value = possible_value
        available_cells.first.possible_values = []
      end
    end
  end

  def is_any_cell_impossible?
    @board.any? {|cell| cell.possible_values.empty? && cell.value == 0 }
  end


  def refresh_possible_values
    @board.map! do |cell|
      if cell.value == 0
        cell.possible_values = filter_possible_values(cell)
      end
      cell
    end
  end

  def filter_possible_values selected_cell
    return [] if selected_cell.value != 0
    # The thing that removes other possible values once we select a cell.
    possible_numbers = (1..9).to_a
    @board.select { |cell|
      cell.row == selected_cell.row ||
      cell.column == selected_cell.column ||
      cell.box == selected_cell.box }.each do |cell|
        possible_numbers.delete(cell.value)
    end
    possible_numbers
  end

  # Returns a string representing the current state of the board
  # Don't spend too much time on this method; flag someone from staff
  # if you are.
  def board
    result_string = ''
    @board.each_slice(9) do |row_to_print|
      result_string << "\n"
      row_to_print.each do |cell_value|
        result_string << " #{cell_value.value} "
      end
    end
    result_string
  end
end




class Cell
  attr_reader :row, :column, :box, :index
  attr_accessor :value, :possible_values
  def initialize index, value = 0
    @index = index
    @value = value
    @row = index/9 + 1
    @column = index% 9 + 1
    @box = define_box
    @possible_values = []
  end

  def empty?
    value == 0
  end

  def define_box
     possible_boxes = [[1,2,3],[4,5,6],[7,8,9]]
     possible_boxes = reduce_boxes_selection possible_boxes,@row
     @boxes = reduce_boxes_selection possible_boxes, @column
  end

  def reduce_boxes_selection array, to_match
    if (1..3).include?(to_match)
      return array[0]
    elsif (4..6).include?(to_match)
      return array[1]
    else
      return array[2]
    end
  end

  def to_s
    value.to_s
  end
end


def assert_equal actual, expected
  actual == expected ? true : raise("Expected : #{expected} -  got #{actual}")
end

cell = Cell.new(2)
p assert_equal cell.row, 1
p assert_equal cell.column, 3
p assert_equal cell.box, 1
p assert_equal cell.value, 0

cell = Cell.new(40)
p assert_equal cell.row, 5
p assert_equal cell.column, 5
p assert_equal cell.box, 5
p assert_equal cell.value, 0

p assert_equal cell.value = 5, 5
puts "tests over"




# ### Works for the first ones, but starting with line #9, none of the blank spots has only one possibility.
# board_string = File.readlines('set-01_sample.unsolved.txt').each_with_index do |line, index|
#   game = Sudoku.new(line.chomp)
#   puts "Input board number #{index}"
#   puts game.board
#   game.solve!
#   puts "\nSolved!\n\nResult :\n"
#   puts game.board
#   puts "---------------------------\n\n\n------------------------"
# end



# ### Works for the first ones, but starting with line #9, none of the blank spots has only one possibility.
# board_string = File.readlines('set-02_project_euler_50-easy-puzzles.txt').each_with_index do |line, index|
#   game = Sudoku.new(line.chomp)
#   puts "Input board number #{index}"
#   puts game.board
#   game.solve!
#   puts "\nSolved!\n\nResult :\n"
#   puts game.board
#   puts "---------------------------\n\n\n------------------------"
# end

# ### Works for the first ones, but starting with line #9, none of the blank spots has only one possibility.
# board_string = File.readlines('set-03_peter-norvig_95-hard-puzzles.txt').each_with_index do |line, index|
#   game = Sudoku.new(line.chomp)
#   puts "Input board number #{index}"
#   puts game.board
#   game.solve!
#   puts "\nSolved!\n\nResult :\n"
#   puts game.board
#   puts "---------------------------\n\n\n------------------------"
# end

# ### Works for the first ones, but starting with line #9, none of the blank spots has only one possibility.
# board_string = File.readlines('set-04_peter-norvig_11-hardest-puzzles.txt').each_with_index do |line, index|
#   game = Sudoku.new(line.chomp)
#   puts "Input board number #{index}"
#   puts game.board
#   game.solve!
#   puts "\nSolved!\n\nResult :\n"
#   puts game.board
#   puts "---------------------------\n\n\n------------------------"
# end

require 'benchmark'
Benchmark.bm {|x|
  x.report('Set 1:') do
    board_string = File.readlines('set-01_sample.unsolved.txt').each_with_index do |line, index|
      game = Sudoku.new(line.chomp)
      game.solve!
    end
  end
  x.report('Set 2:') do
    board_string = File.readlines('set-02_project_euler_50-easy-puzzles.txt').each_with_index do |line, index|
      game = Sudoku.new(line.chomp)
      game.solve!
    end
  end
  x.report('Set 3:') do
    board_string = File.readlines('set-03_peter-norvig_95-hard-puzzles.txt').each_with_index do |line, index|
      game = Sudoku.new(line.chomp)
      game.solve!
    end
  end
  x.report('Set 4:') do
    board_string = File.readlines('set-04_peter-norvig_11-hardest-puzzles.txt').each_with_index do |line, index|
      game = Sudoku.new(line.chomp)
      game.solve!
    end
  end

}

# Set 2 : 0.132 per Sudoku
# Set 3 : 0.08 per Sudoku
# Set 4 : 0.04 per Sudoku