class HumanPlayer < StupidPlayer
#[["00", "10", "20"],   y = 0
  # ["01", "11", "21"],   y = 1
  # ["02", "12", "22"]]   y = 2

	POSITION_MATCH = {
		'1': "0|0", '2': "1|0", '3': "2|0", '4': "0|1", '5': "1|1", '6': "2|1", '7': "0|2", '8': "1|2", '9': "2|2"
	}


  def move
  	
    

    validMove = false
    choice = ""
    until validMove
    	puts "Please choose a valid position between 1 - 9: "
    	input = gets.strip

      return "exit" if input == "exit"
      return "save" if input == "save"

    	if input.to_i.between?(1,9)
    		choice = POSITION_MATCH[input.to_sym]
	    
		    move = choice.split("|")

		    validMove = true if self.game.board.board[move[1].to_i][move[0].to_i] == " "
    	end

	  end

	  choice
  end

end