# require_relative "./image_blur/version"
require 'pry'
require_relative './coordinate'

class Image
  attr_reader :image_array

  def initialize(image_array)
    @image_array = image_array
  end

  def output_image
    image_array.each do |row|
      puts row.join
    end
  end

  def blur(distance = 1)
    pixel_coordinates.each do |coord|
      if distance > 1
        big_blur(coord, distance)
      else
        update_NSEW(coord, distance)
      end
    end
  end

  def pixel_coordinates
    coordinates = []
    image_array.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        coordinates << Coordinate.new(row_index, cell_index) if cell == 1
      end
    end
    coordinates
  end

  def update_north(coord, distance = 1)
    turn_pixel_on(coord.north(distance))
  end

  def update_south(coord, distance = 1)
    turn_pixel_on(coord.south(distance))
  end

  def update_east(coord, distance = 1)
    turn_pixel_on(coord.east(distance))
  end

  def update_west(coord, distance = 1)
    turn_pixel_on(coord.west(distance))
  end

  def update_north_column(coord, height = 1)
    1.upto(height) { |h| update_north(coord, h) }
  end

  def update_south_column(coord, height = 1)
    1.upto(height) { |h| update_south(coord, h) }
  end

  def update_northwest_corner(coord, manhattan_distance = 2)
    1.upto(manhattan_distance - 1) do |offset|
      height = manhattan_distance - offset
      update_north_column(coord.west(offset), height)
    end
  end

  def update_northeast_corner(coord, manhattan_distance = 2)
    1.upto(manhattan_distance - 1) do |offset|
      height = manhattan_distance - offset
      update_north_column(coord.east(offset), height)
    end
  end

  def update_southeast_corner(coord, manhattan_distance = 2)
    1.upto(manhattan_distance - 1) do |offset|
      height = manhattan_distance - offset
      update_south_column(coord.east(offset), height)
    end
  end

  def update_north_east(coord, distance = 1)
    coord_NE = coord.north(distance).east(distance)
    turn_pixel_on(coord_NE)
  end

  def update_south_east(coord, distance = 1)
    coord_SE = coord.south(distance).east(distance)
    turn_pixel_on(coord_SE)
  end

  def update_south_west(coord, distance = 1)
    coord_SW = coord.south(distance).west(distance)
    turn_pixel_on(coord_SW)
  end

  def turn_pixel_on(coord)
    image_array[coord.row][coord.col] = 1 if pixel_off?(coord)
  end

  def pixel_off?(coord)
    in_bounds?(coord) && image_array[coord.row][coord.col].zero?
  end

  def in_bounds?(coord)
    (0...image_array.size).cover?(coord.row) &&
      (0...image_array[coord.row].size).cover?(coord.col)
  end

  private

  def big_blur(coord, distance)
    1.upto(distance) do |d|
      update_NSEW(coord, d)
      update_corners(coord, d - 1) if d > 1
    end
  end

  def update_corners(coord, distance)
    update_northwest_corner(coord, distance)
    update_north_east(coord, distance)
    update_south_east(coord, distance)
    update_south_west(coord, distance)
  end

  def update_NSEW(coord, distance)
    update_north(coord, distance)
    update_south(coord, distance)
    update_east(coord, distance)
    update_west(coord, distance)
  end
end
