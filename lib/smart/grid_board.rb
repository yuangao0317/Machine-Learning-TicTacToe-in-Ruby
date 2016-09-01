  require 'pry'

class GridBoard

	#[["00", "10", "20"],   y = 0
  # ["01", "11", "21"],   y = 1
  # ["02", "12", "22"]]   y = 2

	attr_accessor :grid
	attr_reader :board

  EMPTY_CELL = " "

  WIN_COMBINATIONS = [
    ["00", "10", "20"],
    ["01", "11", "21"],
    ["02", "12", "22"],
    ["00", "01", "02"],
    ["10", "11", "12"],
    ["20", "21", "22"],
    ["00", "11", "22"],
    ["20", "11", "02"]
  ]

	def initialize(opts={})
		@grid = 3
		opts.each { |key, value| self.send(("#{key}="), value) }
		self.setup_board
	end



	def setup_board
		@board = _create_new_board unless @board
	end



  def full?
    !@board.flatten.any? { |cell| cell == EMPTY_CELL }
  end



  def update(x, y, token)
    # puts "update board: x: #{x}| y: #{y}"

    unless self.valid_move?(x, y) 
      # puts "updated invalid cell!!!!>>>>>>>> Should not happen in availableMoves"
      return false
    end
    
    @board[y.to_i][x.to_i] = token    
  
    return @board
  end



  def winMove?(x:, y:, token:)
    WIN_COMBINATIONS.detect do |comb| # => [20, 21, 22]
      comb_flag = comb.all? do |xy| 
        xy_a = xy.split('')  # => ['xy']
        y_c = xy_a[1]
        x_c = xy_a[0]

        if x == x_c && y == y_c
          true
        else
          @board[y_c.to_i][x_c.to_i] == token
        end
      end
    end
  end




  def won?(token)
    WIN_COMBINATIONS.detect do |comb| # => [20, 21, 22]
      comb.all? do |xy| 
        xy_a = xy.split('')  # => ['xy']
        @board[xy_a[1].to_i][xy_a[0].to_i] == token
      end
    end
  end



  def valid_move?(x, y)
    # !_taken?(x, y) || @board[x.to_i][y.to_i] == " "

    !_taken?(x, y)
    # puts "#{x}|#{y} taken?: #{taken}"
  end



  def availableMoves  # => ['x|y', 'x|y']
    options = []
    @board.each_with_index do |row, y|    
      row.each_with_index do |cell, x|
        options << "#{x}|#{y}" if cell == EMPTY_CELL
      end
    end
    options
  end



  def reset
    @board = nil
    @board = _create_new_board
  end



  def display
    separator = "-------------"

    @board.each_with_index do |row, x|  
      puts "\n",separator
      row.each_with_index do |cell, y|
        if y == 1
          print " #{@board[x][y]} "
        else
          print "|"
          print " #{@board[x][y]} "
          print "|"
        end
      end
    end
    puts "\n",separator
  end


  ### Getter & Setter ###
  def board
    @board.dup.freeze    # => only update board via update(x, y, token)
  end



	private

	def _create_new_board
		Array.new(@grid) { Array.new(@grid) {EMPTY_CELL} }
	end

	def _taken?(x, y)

    cell = @board[y.to_i][x.to_i]
    
    return !cell == " "#cell == "X" || cell == "O"
  end

 
end