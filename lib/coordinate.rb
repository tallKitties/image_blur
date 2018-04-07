class Coordinate
  attr_accessor :row, :col, :coord

  def initialize(row, col)
    @row = row
    @col = col
    @coord = {row: @row, col: @col}
  end

  def ==(other_coord_obj)
    coord = other_coord_obj.coord
  end

  def north(distance = 1)
    self.class.new(@row - distance, @col)
  end

  def south(distance = 1)
    self.class.new(@row + distance, @col)
  end

  def east(distance = 1)
    self.class.new(@row, @col + distance)
  end

  def west(distance = 1)
    self.class.new(@row, @col - distance)
  end
end