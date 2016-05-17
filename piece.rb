require 'singleton'

class Piece
  attr_reader :kingdom

  def initialize(board, pos, kingdom)
    @board = board
    @pos = pos
    @kingdom = kingdom
  end

  def moves

  end

  def to_s

  end

end

#can move till the end of the board or hits an obstacle
class SlidingPiece < Piece

  def moves
    moves = []
    move_dirs.each do |(x, y)|
      a, b = @pos
      while a.between?(0, 7) && b.between?(0,7)
        a += x
        b += y
        moves << [a, b] if (a.between?(0, 7) && b.between?(0,7))
      end
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
    '\+/'
  end

end

#orthogonal
class Rook < SlidingPiece

  def move_dirs
    return [[0, 1],[0, -1],[1, 0],[-1, 0]]
  end

  def to_s
    " R "
  end
end


#diags
class Bishop < SlidingPiece

  def move_dirs
    return [[1, 1],[-1, -1],[1, -1],[-1, 1]]
  end

  def to_s
    " B "
  end
end

class SteppingPiece < Piece

  def moves
    a, b = @pos
    move_dirs.map do |(x, y)|
      new_pos = [a + x, b + y]
      new_pos if new_pos.all? {|coord| coord.between?(0,7)}
    end
  end
end
#2, 1
class Knight < SteppingPiece

  def move_dirs
    return [[1, 2],[2, 1], [2, -1], [1, -2],
            [-1, -2], [-2, -1],[-2, 1],[-1, 2]]
  end

  def to_s
    " K "
  end

end
#1
class King < SteppingPiece

  def move_dirs
    return [[0, 1], [1, 1], [1, 0],[1, -1], [0, -1],[-1, -1], [-1, 0], [-1, 1]]
  end

  def to_s
    "-+-"
  end

end
#1 in one direction
class Pawn < Piece

  def moves

  end

  def to_s
    " * "
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
