require_relative "piece"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8) {Array.new(8, nil)}
    populate
  end
#board, pos, kingdom
  def populate
    self[[0,0]] = Rook.new(self, [0,0], :blue)
    self[[0,7]] = Rook.new(self, [0,7], :blue)
    self[[0,1]] = Knight.new(self, [0,1], :blue)
    self[[0,6]] = Knight.new(self, [0,6], :blue)
    self[[0,2]] = Bishop.new(self, [0,2], :blue)
    self[[0,5]] = Bishop.new(self, [0,5], :blue)
    self[[0,3]] = Queen.new(self, [0,3], :blue)
    self[[0,4]] = King.new(self, [0,4], :blue)

    @grid[1].each_index do |col_idx|
      @grid[1][col_idx] = Pawn.new(self, [1, col_idx], :blue)
    end

    self[[7,0]] = Rook.new(self, [7,0], :yellow)
    self[[7,7]] = Rook.new(self, [7,7], :yellow)
    self[[7,1]] = Knight.new(self, [7,1], :yellow)
    self[[7,6]] = Knight.new(self, [7,6], :yellow)
    self[[7,2]] = Bishop.new(self, [7,2], :yellow)
    self[[7,5]] = Bishop.new(self, [7,5], :yellow)
    self[[7,4]] = Queen.new(self, [7,4], :yellow)
    self[[7,3]] = King.new(self, [7,3], :yellow)

    @grid[6].each_index do |col_idx|
      @grid[6][col_idx] = Pawn.new(self, [6, col_idx], :yellow)
    end

    (2..5).each do |row_idx|
      (0..7).each do |col_idx|
        self[[row_idx, col_idx]] = NullPiece.instance
      end
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

  def in_bounds?(pos)
    pos.all? {|x| x.between?(0, 7)}
  end

  def in_check?(kingdom)
    king_pos = find_king_pos(kingdom)
    self.flatten.each do |piece|
      if piece.kingdom != kingdom && !piece.is_a?(NullPiece)
    end
  end

  def find_king_pos(kingdom)
    self.flatten.each do |piece|
      if piece.is_a?(King) && piece.kingdom == kingdom
        return piece.pos
      end
    end
  end

  def checkmate?
  end
end
