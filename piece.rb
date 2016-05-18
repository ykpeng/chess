require 'singleton'
require 'byebug'

class Piece
  attr_reader :kingdom, :pos

  def initialize(pos, kingdom)
    @pos = pos
    @kingdom = kingdom
  end

  def moves

  end

  def to_s

  end

  def update_position(pos)
    @pos = pos
  end

end

#can move till the end of the board or hits an obstacle
class SlidingPiece < Piece

  def moves(board)
    moves = []
    move_dirs.each do |(x, y)|
      sub_moves = []
      a, b = @pos
      while a.between?(0, 7) && b.between?(0,7)
        a += x
        b += y
        sub_moves << [a, b] if (a.between?(0, 7) && b.between?(0,7))
        break if sub_moves.last.nil? || board[sub_moves.last].is_a?(Piece)
      end
      sub_moves.pop if !sub_moves.last.nil? && board[sub_moves.last].kingdom == @kingdom
      moves.concat(sub_moves)
    end
    moves
  end
end


#diags and rows
class Queen < SlidingPiece

  def move_dirs
    return [[1, 1],[-1, -1],[1, -1],[-1, 1],[0, 1],[0, -1],[1, 0],[-1, 0]]
  end

  def to_s
    " " + "\u265B".encode('utf-8') + " "
  end

end

#orthogonal
class Rook < SlidingPiece

  def move_dirs
    return [[0, 1],[0, -1],[1, 0],[-1, 0]]
  end

  def to_s
    " " + "\u265C".encode('utf-8') + " "
  end
end


#diags
class Bishop < SlidingPiece

  def move_dirs
    return [[1, 1],[-1, -1],[1, -1],[-1, 1]]
  end

  def to_s
    " " + "\u265D".encode('utf-8') + " "
  end
end

class SteppingPiece < Piece

  def moves(board)
    # debugger
    a, b = @pos
    moves = []
    move_dirs.each do |(x, y)|
      new_pos = [(a + x), (b + y)]
      moves << new_pos if (new_pos.all? {|coord| coord.between?(0,7)} && board[new_pos].kingdom != @kingdom)
    end
    moves
  end
end
#2, 1
class Knight < SteppingPiece

  def move_dirs
    return [[1, 2],[2, 1],[2, -1],[1, -2],
            [-1, -2],[-2, -1],[-2, 1],[-1, 2]]
  end

  def to_s
    " " + "\u265E".encode('utf-8') + " "
  end

end
#1
class King < SteppingPiece

  def move_dirs
    return [[0, 1], [1, 1], [1, 0],[1, -1], [0, -1],[-1, -1], [-1, 0], [-1, 1]]
  end

  def to_s
    " " + "\u265A".encode('utf-8') + " "
  end

end
#1 in one direction
class Pawn < Piece

  def moves(board)
    moves = []
    if @kingdom == :black
      a, b = @pos
      #if it is the starting position
      if a == 1
        moves << [a + 1, b] unless board[[a + 1, b]].is_a?(Piece)
        moves << [a + 2, b] unless board[[a + 2, b]].is_a?(Piece) || board[[a + 1, b]].is_a?(Piece)
      #if its not the starting position
      else
        moves << [a + 1, b] unless board[[a + 1, b]].is_a?(Piece)
      end
      #if there are opposing kingdom pieces diagonally positioned
      potential_move1 = [a + 1, b + 1]
      if potential_move1.all? {|coord| coord.between?(0, 7)} && board[potential_move1].kingdom == :white
        moves << potential_move1
      end
      potential_move2 = [a + 1, b - 1]
      if potential_move2.all? {|coord| coord.between?(0, 7)} && board[potential_move2].kingdom == :white
        moves << potential_move2
      end
    end
    if @kingdom == :white
      a, b = @pos
      #if it is the starting position
      if a == 6
        moves << [a - 1, b] unless board[[a - 1, b]].is_a?(Piece)
        moves << [a - 2, b] unless board[[a - 2, b]].is_a?(Piece) || board[[a - 1, b]].is_a?(Piece)
      #if its not the starting position
      else
        moves << [a - 1, b] unless board[[a - 1, b]].is_a?(Piece)
      end
      #if there are opposing kingdom pieces diagonally positioned
      potential_move1 = [a - 1, b + 1]
      if potential_move1.all? {|coord| coord.between?(0, 7)} && board[potential_move1].kingdom == :black
        moves << potential_move1
      end
      potential_move2 = [a - 1, b - 1]
      if potential_move2.all? {|coord| coord.between?(0, 7)} && board[potential_move2].kingdom == :black
        moves << potential_move2
      end
    end

    moves
  end

  def to_s
    " " + "\u265F".encode('utf-8') + " "
  end
end

class NullPiece
  include Singleton
  attr_reader :kingdom

  def initialize
    @kingdom = :pink
  end

  def to_s
    "   "
  end
end
