class TicTacToeTraining

  DELIMITER = '|'

  GAME_STATE = {
  	'OVER': "OVER",
  	'IN_PROGRESS': "IN_PROGRESS",
  	'NOT_START': "NOT_START"
  }

  PLAYER_STATE = {
			'ALIVE': "ALIVE",
			'WIN': "WIN",
			'LOSE': "LOSE",
			'DRAW': "DRAW"
	}

	PLAYER_TAG = {
		'SMART': "SMART",
		'NORMAL': "NORMAL"
	}

	attr_accessor :players, :currentPlayer, :matrix, :player1, :player2
	attr_reader :isTraining, :board, :state, :count, :mode, :training_goal  #10000 per min

	# {
	# 	:state1 => {
	# 		'x|y': q-value,
	# 		'x|y': q-value
	# 	},
	# 	:state2 => {
	# 		'x|y': q-value
	# 	}
	# }

	@@totalPlayed = []

	def initialize(player1, player2, opts={})
		opts.each { |key, value| self.send(("#{key}="), value) }
		@matrix = $matrix
		@player1 = player1
		@player2 = player2

		self.setupGame
	end

	def setupGame
		@board = GridBoard.new
		@player1.joinGame(self)
		@player2.joinGame(self)
		@players = [player1, player2]
		@isTraining = false
		@state = GAME_STATE[:NOT_START]
		@count = 0
	end

	def setFirstPlayer(player)
		@currentPlayer = player
	end

	def setTrainingGoal(count)
		@training_goal = count
	end

	def setGameMode(mode)
		@mode = mode
	end


	def startTraining

		@isTraining = true
		@state = GAME_STATE[:IN_PROGRESS]
		puts 'Training system is running ....................'
		# count += 1

		while @isTraining
	      self.training
	    end

    
	    unless @isTraining
	    	puts "Training is over!!!!!!!!!!!!!!!!!!!!!!!"
	    	self.saveMatrix
	    	@state = GAME_STATE[:NOT_START]
	    end

	end


	def saveMatrix
		TrainingDataHelper.addMarixToJSON(file:'db/training_data.json', matrix:self.matrix)

	end

  def training
  	unless self.currentPlayer
  		puts "First Player automaticlly set to Player 1."

  	end
  	# if @matrix.length == 0


  	# else
  	# 	move = player.determineAction(@board.board, PLAYER_STATE['alive'])
  	# end


  	# get position
  	move = self.currentPlayer.move

  	return if move == "exit"
  	case move
	  	when "exit"
	  		@isTraining = false
	  		return
	  	when "save"
	  		self.saveMatrix
	  		return
	  	else
  	end


  	moveArray = self.symbolToXYForMove(move)
  	x = moveArray[0]
  	y = moveArray[1]

  	# puts "choosen action: #{move}"


  	####  state updated!!!!!!
  	# if @board.valid_move?(x, y)
  	if @board.board[y.to_i][x.to_i] == " "
  		puts "#{self.currentPlayer.tag}" if self.currentPlayer.tag
  		@board.update(x, y, self.currentPlayer.token)    # =>  board or false


  		puts "Player #{self.currentPlayer.token} moved: #{move}" if @mode == "Play"
	  	@board.display #if @mode == "Play"

	  	# if won? || draw?

	  	# else
	  	# 	opponent = self.getOpponent(currentPlayer)
	  	# 	newStateKey = opponent.getStateKeyOfCurrentBoard
	  	# 	opponent.setState(PLAYER_STATE[:alive], newStateKey)


	  	# end

	  	
	  	opponent = self.getOpponent(self.currentPlayer)
	  	if won?(self.currentPlayer.token)
	  		puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #{self.currentPlayer.token} won the game !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" #if @mode == "Play"

	  		@state = GAME_STATE[:win]


	  		
	  		if self.currentPlayer.instance_of?(SmartPlayer) && self.currentPlayer.tag == PLAYER_TAG[:SMART]   # => smart player won
	  			puts "SMART WON"
		  		newStateKey = self.currentPlayer.getStateKeyOfCurrentBoard

		  		self.currentPlayer.total += 1
		  		self.currentPlayer.wins += 1
		  		self.currentPlayer.setState(PLAYER_STATE[:WIN], newStateKey)   # => newState Wrong, self played last move
		  		self.currentPlayer = opponent

		  		# binding.pry
		  		# if self.currentPlayer.tag   # => human tag is nil
		  		# 	opponent = self.getOpponent(self.currentPlayer)		# => non smart player won
			  	# 	# binding.pry
			  	# 	newStateKey = opponent.getStateKeyOfCurrentBoard
			  	# 	opponent.total += 1
			  	# 	opponent.loses += 1
			  	# 	opponent.setState(PLAYER_STATE[:LOSE], newStateKey) 
		  		# end
		  	elsif self.currentPlayer.tag != PLAYER_TAG[:SMART] && opponent.tag == PLAYER_TAG[:SMART]
		  		puts "NORMAL WON"
		  		# opponent = self.getOpponent(self.currentPlayer)		# => non smart player won
		  		
		  		# binding.pry
		  		newStateKey = opponent.getStateKeyOfCurrentBoard
		  		opponent.total += 1
		  		opponent.loses += 1
		  		opponent.setState(PLAYER_STATE[:LOSE], newStateKey)  		# => 
		  		
		  	end
	  		puts "who won #{self.currentPlayer.tag}"
	  		self.gameOverAndReset

	  	elsif draw?(self.currentPlayer.token)
	  		puts "?????????????????????????????????? This is a draw game ??????????????????????????????????" #if @mode == "Play"

	  		if self.currentPlayer.instance_of?(SmartPlayer)	&& self.currentPlayer.tag == PLAYER_TAG[:SMART] 	# => smart player draw

		  		newStateKey = self.currentPlayer.getStateKeyOfCurrentBoard

		  		self.currentPlayer.total += 1
		  		self.currentPlayer.setState(PLAYER_STATE[:DRAW], newStateKey)
		  		self.currentPlayer = opponent   # => keep smart play as O
		  		# bingding.pry

		  		# if self.currentPlayer.tag 
		  		# 	opponent = self.getOpponent(self.currentPlayer)			# => non smart player draw, score smart player
			  	# 	newStateKey = opponent.getStateKeyOfCurrentBoard
			  	# 	# binding.pry
			  	# 	opponent.total += 1
			  	# 	opponent.setState(PLAYER_STATE[:DRAW], newStateKey)
		  		# end
		  	else
		  		# opponent = self.getOpponent(self.currentPlayer)			# => non smart player draw, score smart player
		  		newStateKey = opponent.getStateKeyOfCurrentBoard
		  		# binding.pry
		  		opponent.total += 1
		  		opponent.setState(PLAYER_STATE[:DRAW], newStateKey)
		  		# binding.pry

		  	end

				
				self.gameOverAndReset

	  	else  # isTraining
	  		puts ">>>>>>>>>>>>>>>>>>>>>>>>>>> Players are playing >>>>>>>>>>>>>>>>>>>>>>>>>>>" if @mode == "Play"


	  		lastPlayer = self.getOpponent(self.currentPlayer)

	  		# if lastPlayer.tag && self.currentPlayer.tag  # => two smart player
	  		# 	newStateKey = lastPlayer.getStateKeyOfCurrentBoard
	  		# 	lastPlayer.setState(PLAYER_STATE[:ALIVE], newStateKey)
	  		# end

	  		
	  		#!!!!!!!!!!!!!!!!!! bug if two smart computers
	  		# 
	  		if !self.currentPlayer.instance_of?(SmartPlayer) && self.currentPlayer.tag != PLAYER_TAG[:SMART]   # => score the last move after op played
	  			puts lastPlayer.tag
	  			newStateKey = lastPlayer.getStateKeyOfCurrentBoard
	  			lastPlayer.setState(PLAYER_STATE[:ALIVE], newStateKey)
	  			# binding.pry
	  		end
	  		self.currentPlayer = lastPlayer
	  		
	  	end

  	else
  		puts "invalid move, x: #{x}, y: #{y}"
  	end


  end

  def gameOverAndReset
  	@state = GAME_STATE[:OVER]
	self.count += 1
  	@board.reset
  	# self.currentPlayer = self.getOpponent(self.currentPlayer) if self.currentPlayer.token == "O"
  	# self.player1.reset
  	# self.player2.reset
  end

  def won?(token)
  	# puts "currentPlayer: #{self.currentPlayer.token}"
  	comb = @board.won?(token)
  end


  def draw?(token)
    @board.full? && !self.won?(token)
  end

  def getOpponent(currentPlayer)
  	# self.currentPlayer = nil
  	currentPlayer == self.player1 ? self.player2 : self.player1
  end

  def symbolToXYForMove(move)  # =>   
  	move.split(DELIMITER)
  end


  ### Getter & Setter ###
  def board=(board)
  	@board = board unless board
  end

  def grid=(grid)
  	@grid = grid unless grid
  end



  def count=(count)
  	@count = count
  	@isTraining = false if @count == @training_goal
  	self.saveMatrix if @count % 50000 == 0
  	@count
  end


end