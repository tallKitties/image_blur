# require_relative "./image_blur/version"
require 'pry'
require_relative './coordinate'

class Image
  attr_reader :image_array, :distance

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

  def update_north_west(coord, distance = 1)
    coord_NW = coord.north(distance).west(distance)
    turn_pixel_on(coord_NW)
  end

  def turn_pixel_on(coord)
    image_array[coord.row][coord.col] = 1 if in_bounds?(coord)
  end

  def in_bounds?(coord)
    (0...image_array.size).cover?(coord.row) &&
      (0...image_array[coord.row].size).cover?(coord.col)
  end

  private

  def big_blur(coord, distance)
    distance.times do |d|
      update_north_west(coord, distance)
    end
  end

  def update_NSEW(coord, distance)
    update_north(coord, distance)
    update_south(coord, distance)
    update_east(coord, distance)
    update_west(coord, distance)
  end
end
