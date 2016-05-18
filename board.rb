require 'byebug'
require_relative "piece"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
    populate
  end
#board, pos, kingdom
  def populate
    self[[0,0]] = Rook.new([0,0], :black)
    self[[0,7]] = Rook.new([0,7], :black)
    self[[0,1]] = Knight.new([0,1], :black)
    self[[0,6]] = Knight.new([0,6], :black)
    self[[0,2]] = Bishop.new([0,2], :black)
    self[[0,5]] = Bishop.new([0,5], :black)
    self[[0,3]] = Queen.new([0,3], :black)
    self[[0,4]] = King.new([0,4], :black)

    @grid[1].each_index do |col_idx|
      @grid[1][col_idx] = Pawn.new([1, col_idx], :black)
    end

    self[[7,0]] = Rook.new([7,0], :white)
    self[[7,7]] = Rook.new([7,7], :white)
    self[[7,1]] = Knight.new([7,1], :white)
    self[[7,6]] = Knight.new([7,6], :white)
    self[[7,2]] = Bishop.new([7,2], :white)
    self[[7,5]] = Bishop.new([7,5], :white)
    self[[7,3]] = Queen.new([7,3], :white)
    self[[7,4]] = King.new([7,4], :white)

    @grid[6].each_index do |col_idx|
      @grid[6][col_idx] = Pawn.new([6, col_idx], :white)
    end

    (2..5).each do |row_idx|
      (0..7).each do |col_idx|
        self[[row_idx, col_idx]] = NullPiece.instance
      end
    end
  end

  def move(start_pos, end_pos)
    #start nil
    raise if self[start_pos].is_a?(NullPiece)
    piece = self[start_pos]
    #check for valid move
    raise unless piece.moves(self).include?(end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    piece.update_position(end_pos)
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end

  def in_bounds?(pos)
    pos.all? {|x| x.between?(0, 7)}
  end

  def in_check?(kingdom)
    king_pos = find_king_pos(kingdom)
    self.grid.flatten.each do |piece|
      # debugger if piece.nil?
      if piece.kingdom != kingdom && !piece.is_a?(NullPiece)
        return true if piece.moves(self).include?(king_pos)
      end
    end
    false
  end

  def checkmate?(kingdom)
    # debugger
    self.grid.flatten.each do |piece|
      if piece.kingdom == kingdom
        piece.moves(self).each do |move|
          return false if !still_checked?(piece, move)
        end
      end
    end

    true
  end

  def still_checked?(piece, move)
    checked = false
    saved_start_piece, saved_start_pos = piece, piece.pos
    saved_end_piece, saved_end_pos = self[move], move
    #do
    self[saved_end_pos], self[saved_start_pos]= self[saved_start_pos], NullPiece.instance
    piece.update_position(saved_end_pos)

    checked = true if in_check?(piece.kingdom)
    #undo
    self[saved_start_pos], self[saved_end_pos]= saved_start_piece, saved_end_piece
    piece.update_position(saved_start_pos)

    checked
  end


  def find_king_pos(kingdom)
    self.grid.flatten.each do |piece|
      if piece.is_a?(King) && piece.kingdom == kingdom
        return piece.pos
      end
    end
  end

end
