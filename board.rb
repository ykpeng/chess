require_relative "piece"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) {Array.new(8, nil)}
    populate
  end

  def populate
    @grid[0].each_index do |column_idx|
      @grid[0][column_idx] = Piece.new
    end
    @grid[1].each_index do |column_idx|
      @grid[1][column_idx] = Piece.new
    end
    @grid[6].each_index do |column_idx|
      @grid[6][column_idx] = Piece.new
    end
    @grid[7].each_index do |column_idx|
      @grid[7][column_idx] = Piece.new
    end
  end

  def move(start_pos, end_pos)
    #start nil
    raise if self[start_pos].nil?
    piece = self[start_pos]
    #check for valid move
    raise unless piece.valid_move?
    self[end_pos] = self[start_pos]
    self[start_pos] = nil
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
  end
end

p Board.new.grid
