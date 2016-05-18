require "colorize"
require_relative "board"
require_relative "cursorable"

class Display
  include Cursorable
  attr_reader :selected


  def initialize(board)
    @board = board
    @cursor_pos = [6, 3]
    @selected = false
  end

  def build_grid
    @board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j, piece)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j, piece)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif (i + j).odd?
      bg = :light_white
    else
      bg = :light_magenta
    end
    { background: bg, color: piece.kingdom  }
  end

  def render
    system("clear")
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."
    build_grid.each { |row| puts row.join }
  end

  def move
    result = nil
    until result
      render
      result = get_input
    end
    result
  end
end

# b = Board.new
#
# a = Display.new(b)
# p a.move
