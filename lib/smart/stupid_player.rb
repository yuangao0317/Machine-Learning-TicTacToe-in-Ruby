class StupidPlayer

	attr_accessor :game
	attr_reader :token, :tag

	def initialize(token)
		@token = token
	end

	def joinGame(game)  # => must execute to join a game !
		@game = game
	end

	def changeToken(token)
		@token = token
	end	

	def reset

	end

	def move

		choices = self.game.board.availableMoves   # => ['x|y', 'x|y']
		
		return choices[rand(choices.length - 1)]
	end


end