

class SmartPlayer

	include AISystem::Q

	attr_accessor :total, :wins, :loses, :matrix, :lastStateKey, :lastActionKey, :lastActionQValue, :newStateKey, :nextBestMove#, :currentStateKey, :currentActionKey,
	attr_reader :game, :state, :token, :tag

	  PLAYER_STATE = {
			'ALIVE': "ALIVE",
			'WIN': "WIN",
			'LOSE': "LOSE",
			'DRAW': "DRAW"
	}

	def initialize(token, opts={})
		opts.each { |key, value| self.send(("#{key}="), value) }
		@token = token
		@matrix = $matrix   # => $matrix will change
	end

	def joinGame(game)  # => must execute to join a game !
		@game = game
		@total = 0
		@wins = 0
		@loses = 0
	end

	def changeToken(token)
		@token = token
	end	

	def setTag(tag)
		@tag = tag
	end

	def reset
		self.lastStateKey = nil 
		self.lastActionKey = nil 
		self.lastActionQValue = nil 
		self.newStateKey = nil 
		self.nextBestMove = nil
		@state = PLAYER_STATE[:ALIVE]
	end
	

	def move     #=> Decision: x, y
		### get current state(board) and send it to Q, get Action {x, y}
		# stateKey = self.getStateKeyOfCurrentBoard

		# availableOptions = self.game.board.availableMoves  # => ['x|y', 'x|y']

		# ## find the action with the max qValue
		# if !self.matrix[stateKey]
		# 	## create current state 
		# 	currentStateKey = self.getStateKeyOfCurrentBoard
		# 	self.matrix[currentStateKey] = {}
		# end

		# availableActions = {}    # => {'x|y': {key: x|y, qValue: 1}, 'x|y': {key: x|y, qValue: 1}}
		# availableOptions.each do |option| # => option: 'x|y'
		# 	if !@matrix[stateKey][option]
		# 		## give qValue 0
		# 		@matrix[stateKey][option] = 0
		# 	end
		# 	availableActions[option] = {key: option, qValue: @matrix[stateKey][option]}
		# end
		puts "===================START====================" if self.game.mode == "Play"
		currentStateKey = self.getStateKeyOfCurrentBoard
		
		action = self.determineAction(currentStateKey)   # => player must be alive here, update last action qValue,  'x|y'

		return action
	end

	def getStateKeyOfCurrentBoard

		stateKey = _hashStateOfBoardToKey(self.game.board.board, self.token)  # => game board is updated by OP

		# binding.pry
	end


	def _setGlobalMatrix(matrix)
		$matrix = matrix.dup
	end

	def _hashStateOfBoardToKey(board, token)
		# binding.pry
		
		flatten = board.flatten
		
		result = flatten.collect do |cell|

			if cell == " "
				'E'
			else
				# cell == token ? CURRENT : cell
				cell
			end

		end

		result = result.join("")#unshift(token).join("")

		result

		# binding.pry
	end




	### Getter & Setter ###


  







end