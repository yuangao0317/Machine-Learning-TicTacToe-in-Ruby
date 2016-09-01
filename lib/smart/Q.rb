require 'pry'

module AISystem

	module Q

		# matrix:
			# {
			# 	:state1 => {
			# 		'x|y': q-value,
			# 		'x|y': q-value
			# 	},
			# 	:state2 => {
			# 		'x|y': q-value
			# 	}
			# }


		DELIMITER = '|'

		REWARDS = {
			'ALIVE': 1,
			'WIN': 10,
			'LOSE': -2000,
			'DRAW': 1
		}

		CONFIG = {
			'alpha': 0.3,
			'discount': 0.2
		}

	  PLAYER_STATE = {
			'ALIVE': "ALIVE",
			'WIN': "WIN",
			'LOSE': "LOSE",
			'DRAW': "DRAW"
		}

		

		def setState(playerState, newStateKey)   # => have to set player's state after every move
			@state = nil
	  	@state = playerState
	  	self.newStateKey = nil
	  	self.newStateKey = newStateKey

	  	self.calculateQValueForLastAction(self.state)
	  end

	  def findBestMove(stateKey)
	  	####### check next best move, will reduce the training time by time ######
			actions = self.matrix[stateKey]
			nextBestMove = nil

			# puts "==========================================" if self.game.mode == "Play"
			# puts "actions for win move: #{actions}" if self.game.mode == "Play"
			if actions

				actions = actions.sort_by {|k, v| v}

				### check my win move
				actions.each do |action|
					xy = action[0].split(DELIMITER)
					if self.game.board.winMove?(x:xy[0], y:xy[1], token:self.token)
						unless nextBestMove 
							nextBestMove = action[0] 				# => found win move
						end
						
						# puts "self: #{self.token}, next best move: #{self.nextBestMove}" if self.game.mode == "Play"
					end
				end

				# check OP win move if self does not have a win move, only for NORMAL
				if self.tag == "NORMAL"
					unless nextBestMove
						actions.each do |action|
							xy = action[0].split(DELIMITER)
							if self.game.board.winMove?(x:xy[0], y:xy[1], token:_opponentToken(self.token))
								unless nextBestMove 
									nextBestMove = action[0] 				# => found win move
								end
								# puts "OP: #{self.token}, next best move: #{self.nextBestMove}" if self.game.mode == "Play"
							end
						end
					end
				end
			end # => actions

			nextBestMove   # => 'x|y' or nil

	  end


		def determineAction(currentStateKey)	# => can use player's own board
			### get current state key
			# currentStateKey = self.getStateKeyOfCurrentBoard

			# binding.pry

			# stateKey = self.getStateKeyOfCurrentBoard

			# ### get current state available options
			# availableOptions = self.game.board.availableMoves  # => ['x|y', 'x|y']

			# ## find the action with the max qValue
			# if !self.matrix[currentStateKey]
			# 	## create current state 
			# 	self.matrix[currentStateKey] = {}
			

			# 	# availableActions = {}    # => {'x|y': {key: x|y, qValue: 1}, 'x|y': {key: x|y, qValue: 1}}
			# 	availableOptions.each do |option| # => option: 'x|y'
			# 		if !self.matrix[currentStateKey][option]
			# 			## give qValue 0
			# 			self.matrix[currentStateKey][option] = 0
			# 		end
			# 		# availableActions[option] = {key: option, qValue: self.matrix[currentStateKey][option]}
			# 	end
			# end
			finalAction = nil
			#puts "current state key: #{currentStateKey}" if self.game.mode == "Play"
			#puts "current action: #{self.matrix[currentStateKey]}" if self.game.mode == "Play"
			_initializeState(currentStateKey) unless self.matrix[currentStateKey]



			# ####### check next best move, will reduce the training time by time ######
			# actions = self.matrix[currentStateKey]
			# self.nextBestMove = nil
			# # puts "==========================================" if self.game.mode == "Play"
			# # puts "actions for win move: #{actions}" if self.game.mode == "Play"
			# if actions

			# 	actions = actions.sort_by {|k, v| v}

			# 	### check my win move
			# 	actions.each do |action|
			# 		xy = action[0].split(DELIMITER)
			# 		if self.game.board.winMove?(x:xy[0], y:xy[1], token:self.token)
			# 			unless self.nextBestMove 
			# 				self.nextBestMove = action[0] 				# => found win move
			# 			end
						
			# 			# puts "self: #{self.token}, next best move: #{self.nextBestMove}" if self.game.mode == "Play"
			# 		end
			# 	end

			# 	# check OP win move if self does not have a win move
			# 	unless self.nextBestMove
			# 		actions.each do |action|
			# 			xy = action[0].split(DELIMITER)
			# 			if self.game.board.winMove?(x:xy[0], y:xy[1], token:_opponentToken(self.token))
			# 				unless self.nextBestMove 
			# 					self.nextBestMove = action[0] 				# => found win move
			# 				end
							
			# 				# puts "OP: #{self.token}, next best move: #{self.nextBestMove}" if self.game.mode == "Play"
			# 			end
			# 		end
			# 	end
			# end




			self.nextBestMove = self.findBestMove(currentStateKey) if self.tag == "NORMAL"
			


			if self.nextBestMove
				# puts "Best move matched !!!!!!!!!! #{self.nextBestMove}" if self.game.mode == "Play"
				finalAction = self.nextBestMove

			else   # => X first move has no self.nextBestMove
				#puts "must be X first move here" if self.game.mode == "Play"
				actions = self.matrix[currentStateKey].sort_by {|k, v| v}  # {'x|y': 1, 'x|y': 2}
				actionWithMaxQ = actions.last[0]    # => 'x|y'
				actionWithMinQ = actions.first[0]

				if self.matrix[currentStateKey][actionWithMinQ] == self.matrix[currentStateKey][actionWithMaxQ]   # new state

					finalAction = actions[rand(actions.length - 1)][0]      # => if there is no best move, generate a random move
				else
					finalAction = actionWithMaxQ
				end
  
			end



			puts "#{self.matrix[currentStateKey]}" if self.game.mode == "Play"
			puts "This turn move: #{self.nextBestMove}" if self.game.mode == "Play"

			
			# puts "self: #{self.token}, this turn move: #{finalAction}" if self.game.mode == "Play"
			

			# @lastStateKey = currentStateKey
			# @lastActionKey = finalAction


			self.lastStateKey = nil
			self.lastActionKey = nil
			self.lastActionQValue = nil
			
			self.lastStateKey = currentStateKey
			self.lastActionKey = finalAction
			self.lastActionQValue = self.matrix[currentStateKey][finalAction]
			# binding.pry




			# puts "=========================================================================================="
			# puts "this state choices: #{self.matrix[currentStateKey]}"
			# puts "this state: #{currentStateKey}, moved to: #{finalAction}, Q-value: #{self.matrix[currentStateKey][actionWithMaxQ]}"



			# binding.pry
			# self.calculateQValueForLastAction(board, playerState)

			# @lastStateKey = currentStateKey
			# @lastAction = finalAction


			return finalAction  # => 'x|y'
		end


		#### call after game.board updated
		def calculateQValueForLastAction(playerState)  # => board is new board after OP placed a move
			# if !self.currentStateKey || !self.currentActionKey

			if !self.newStateKey
				# binding.pry
				puts 'new state is nil'
				return 
			end


			#  opponent must updated the board here
			
			
			
			# binding.pry


			# puts "player state: #{playerState}"
			# unless self.matrix[self.newStateKey]
			# 	puts "#{self.token} self.matrix[self.newStateKey] is nil: #{self.newStateKey}"
			# 	# return 
			# end

			unless self.matrix[self.newStateKey]    # first play does not have matrix and when game is over, there is no available move
				_initializeState(self.newStateKey) 
			end

			self.nextBestMove = nil
			newActionQValue = 0

			if playerState == PLAYER_STATE[:WIN] || playerState == PLAYER_STATE[:LOSE] || playerState == PLAYER_STATE[:DRAW] # => self play win or (OP play win) = self lose
				
				 # => already win, don't need the max Q of next actions
				case playerState
				when PLAYER_STATE[:WIN]
					newActionQValue = REWARDS[:WIN]
				when PLAYER_STATE[:LOSE]
					newActionQValue = REWARDS[:LOSE]
				when PLAYER_STATE[:DRAW]
					newActionQValue = REWARDS[:DRAW]
				else
				end

			elsif self.matrix[self.newStateKey]   # =>  alive after OP played a move, and generate self.nextBestMove to guide next move and newActionQValue

				### get next max Q
				actions = nil

				self.nextBestMove = self.findBestMove(self.newStateKey)  # => the best move may be not the best if OP has two win position
				
				
				# => OP played last position on board
				# found newStateKey, but there are no actions
				if !self.nextBestMove

					actions = self.matrix[self.newStateKey]   # [[:key, 1], [:key2, 2]] 
					#puts "actions: #{actions}" if self.game.mode == "Play"
					unless actions.empty?  # => must has actions here, may be {}
						actions = actions.sort_by {|k, v| v}

						actionWithMaxQ = actions.last[0]    # => 'x|y'
						actionWithMinQ = actions.first[0]

						if self.matrix[self.newStateKey][actionWithMinQ] == self.matrix[self.newStateKey][actionWithMaxQ]   # new state

							actionWithMaxQ = actions[rand(actions.length - 1)][0]      # => no win move, then use the best Q action for next move if there is no win move
							self.nextBestMove = actionWithMaxQ
						else
							self.nextBestMove = actionWithMaxQ
						end

					end	# => actions
					
					#puts "#{self.tag} Generate a move for next turn: #{self.nextBestMove} on state #{self.newStateKey}" #if self.game.mode == "Play"
				else
					#puts "#{self.tag} Found a best move for next turn: #{self.nextBestMove} !!!!!!!!!!!" #if self.game.mode == "Play"
				end # => !self.nextBestMove

				  



				####### check win move ######
				# actionWithMaxQ = nil
				# puts "actions for win move: #{actions}" if self.game.mode == "Play"
				# if actions
				# 	actions = actions.sort_by {|k, v| v}

				# 	actionWithMaxQ = actions.last[0]    # => 'x|y'
				# 	actionWithMinQ = actions.first[0]

				# 	if self.matrix[currentStateKey][actionWithMinQ] == self.matrix[currentStateKey][actionWithMaxQ]   # new state

				# 		actionWithMaxQ = actions[rand(actions.length - 1)][0]      # => no win move, then use the best Q action for next move if there is no win move
						
				# 		self.nextMove = actionWithMaxQ
				# 	end
					# self.nextBestMove = nil
					# puts "=========================================="
					# puts "#{actions}"
					# actions.each do |action|
					# 	xy = action[0].split(DELIMITER)
					# 	if self.game.board.winMove?(x:xy[0], y:xy[1], token:self.token)
					# 		unless self.nextBestMove 
					# 			self.nextBestMove = action[0] 				# => found win move
					# 			actionWithMaxQ = self.nextBestMove
					# 		end
							
					# 		puts "player: #{self.token}, next best move: #{actionWithMaxQ}"
					# 	end
					# end




					# actionWithMaxQ = actions.last[0] unless actionWithMaxQ # => 'x|y'   # => no win move, then use the best Q action for next move
				# end

				newActionQValue = self.matrix[self.newStateKey][self.nextBestMove] || 0 if newActionQValue == 0
			else # => draw
				newActionQValue = 0
			end
			   # actions.last[1]



			# reward = _analyzeNewState(self.newStateKey, actionWithMaxQ)

			reward = REWARDS[playerState.to_sym]    # get the reward of last move after OP played

			# lastActionQValue = 0
			# lastStateKey = nil
			# lastActionKey = nil
			# if !self.lastStateKey || !self.lastActionKey
			# 	# binding.pry
			# 	lastStateKey = @currentStateKey
			# 	lastActionKey = @currentActionKey
			# 	lastActionQValue = 0
			# else
			# 	# binding.pry
			# 	lastStateKey = @lastStateKey
			# 	lastActionKey = @lastActionKey
			# 	lastActionQValue = self.matrix[lastStateKey][lastActionKey]
			# end


			
			


			# if !lastActionQValue
			# 	puts 'lastActionQValue is nil'
			# 	return 
			# end

			# # binding.pry

			# if !self.matrix[@currentStateKey]

			# end








			# currentActionQValue = self.matrix[self.currentStateKey]

			# [self.currentActionKey] || 1







			
			# q = (1 - CONFIG[:discount]) * self.currentActionQValue + CONFIG[:alpha] * (reward + CONFIG[:discount] * newActionQValue)# - self.currentActionQValue)

			if self.lastActionQValue && reward && newActionQValue && self.matrix[self.lastStateKey] && self.lastActionKey
				q = nil
				q = self.lastActionQValue + CONFIG[:alpha] * (reward + CONFIG[:discount] * newActionQValue - self.lastActionQValue)

				self.matrix[self.lastStateKey][self.lastActionKey] = q.round(5)

				# $matrix = self.matrix
				#puts "player: #{self.token} state: #{playerState}, reward: #{reward}, Q: #{q.round(5)}"# if self.game.mode == "Play"
				# puts "newStateKey: #{newStateKey},    newAction: #{actionWithMaxQ},   nextMoveQValue: #{newActionQValue}"
				#puts "lastPlayedStateKey: #{self.lastStateKey}, lastPlayedAction: #{self.lastActionKey}, lastActionQValue: #{lastActionQValue},  updatedQValue: #{self.matrix[self.lastStateKey][self.lastActionKey]}"# if self.game.mode == "Play"
				# puts "depends on new state: #{self.newStateKey}, new action: #{actionWithMaxQ}, newActionMaxQValue: #{newActionQValue}" if self.game.mode == "Play"
				# puts "last state: #{self.lastStateKey}, move: #{self.lastActionKey},  old Q: #{self.lastActionQValue}, updated to #{self.matrix[self.lastStateKey][self.lastActionKey]}"
				# puts "=========================================================================================="

				
			else
				puts "No any state after OP moved!!!!!!!!!" if self.game.mode == "Play"
			end

			self.lastStateKey = nil
			self.lastActionKey = nil
			self.lastActionQValue = nil
			puts "===================END====================" if self.game.mode == "Play"
		end


		def _initializeState(stateKey)
			### get stateKey available options, self.game.board may be wrong!!!!!!!!!!!!!!!!!!!!!!#######$$$$$$$$ after opponent updated board
			puts "initialized state: #{stateKey}" if self.game.mode == "Play"

			## find the action with the max qValue
			if !self.matrix[stateKey]
				availableOptions = self.game.board.availableMoves  # => ['x|y', 'x|y']
				## create stateKey 
				self.matrix[stateKey] = {}
			
				
				# availableActions = {}    # => {'x|y': {key: x|y, qValue: 1}, 'x|y': {key: x|y, qValue: 1}}
				availableOptions.each do |option| # => option: 'x|y'

					if !self.matrix[stateKey][option]
						## give qValue 0
						self.matrix[stateKey][option] = 0
					end
					# availableActions[option] = {key: option, qValue: self.matrix[stateKey][option]}
				end
			end

			# puts "availableOptions: #{availableOptions}"

		end


		

		def _opponentToken(token)
			token == "X" ? "O" : "X"
		end



	end	

end