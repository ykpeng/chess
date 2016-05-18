require_relative 'manifest'

class Game

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @current_kingdom = :white
    @waiting_kingdom = :black
    # @selected
  end

  def play
    checkmated = false

    until checkmated
      puts "#{@current_kingdom.to_s.upcase}'s turn"
      play_turn
      swap_kingdoms
      if @board.in_check?(@current_kingdom)
        puts "in check"
        sleep(1)
        # debugger
        checkmated = true if @board.checkmate?(@current_kingdom)
      end
    end

    puts "#{@waiting_kingdom} has won."
  end

  def play_turn

    puts "Select a piece"

    start_pos = @display.move
    # @selected = true
    selected_piece = @board[start_pos]
    raise unless selected_piece.kingdom == @current_kingdom

    puts "Where will you place the piece?"

    end_pos = @display.move

    @board.move(start_pos, end_pos)
    @display.render
  rescue
    puts "Invalid Move - Try Again"
    retry
  end

  def swap_kingdoms
    @current_kingdom, @waiting_kingdom = @waiting_kingdom, @current_kingdom
  end



end


if __FILE__ == $PROGRAM_NAME
  a = Game.new
  a.play
end
