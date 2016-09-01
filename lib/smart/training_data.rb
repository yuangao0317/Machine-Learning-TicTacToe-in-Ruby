class TrainingDataHelper

	# {
	# 	:state1 => {
	# 		'x|y': q-value,
	# 		'x|y': q-value
	# 	},
	# 	:state2 => {
	# 		'x|y': q-value
	# 	}
	# }	

# 	def self.insertNewMatrxIntoDB(matrix)
# # INSERT INTO 'tablename' ('column1', 'column2') VALUES
#   #   ('data1', 'data2'),
#   #   ('data1', 'data2'),
#   #   ('data1', 'data2'),
#   #   ('data1', 'data2');
#   	matrix.each do |stateKey, actions|
#   		DB[:conn].execute("INSERT OR IGNORE INTO training_data_states state_key VALUES ?", stateKey)
#   		actions.each do |actionKey, qValue|

#   			DB[:conn].execute("INSERT INTO training_data_actions (action_key, q_value, state_key) VALUES (?, ?, ?)", actionKey, qValue, stateKey)
#   		end
#   	end
# 	end

# 	def self.values_for_insert(matrix)

# 	end

	def self.addMarixToJSON(file:, matrix:)
		File.open(file,"w") do |f|
		  f.write(JSON.generate(matrix))
		end
	end

	def self.loadMatrixFromJSON(file) # => matrix

		file_data = File.read(file)
		file_data.length > 0 ? JSON.parse(file_data) : {}
	end



end