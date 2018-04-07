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
      puts row.join(' ')
    end
  end

  def blur(radius = 1)
    pixel_coordinates.each do |coord|
      if radius > 1
        update_columns(coord, radius)
        update_corners(coord, radius)
      else
        update_NSEW(coord, radius)
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
    return if distance_too_small?(distance, 1)
    turn_pixel_on(coord.north(distance))
  end

  def update_south(coord, distance = 1)
    return if distance_too_small?(distance, 1)
    turn_pixel_on(coord.south(distance))
  end

  def update_east(coord, distance = 1)
    return if distance_too_small?(distance, 1)
    turn_pixel_on(coord.east(distance))
  end

  def update_west(coord, distance = 1)
    return if distance_too_small?(distance, 1)
    turn_pixel_on(coord.west(distance))
  end

  def update_north_column(coord, height = 1)
    return if distance_too_small?(height, 1)
    1.upto(height) { |h| update_north(coord, h) }
  end

  def update_south_column(coord, height = 1)
    return if distance_too_small?(height, 1)
    1.upto(height) { |h| update_south(coord, h) }
  end

  def update_east_row(coord, width = 1)
    return if distance_too_small?(width, 1)
    1.upto(width) { |h| update_east(coord, h) }
  end

  def update_west_row(coord, width = 1)
    return if distance_too_small?(width, 1)
    1.upto(width) { |h| update_west(coord, h) }
  end

  def update_northwest_corner(coord, manhattan_dist = 2)
    return if distance_too_small?(manhattan_dist, 2)
    (1...manhattan_dist).each do |height|
      offset = manhattan_dist - height
      update_north_column(coord.west(offset), height)
    end
  end

  def update_northeast_corner(coord, manhattan_dist = 2)
    return if distance_too_small?(manhattan_dist, 2)
    (1...manhattan_dist).each do |height|
      offset = manhattan_dist - height
      update_north_column(coord.east(offset), height)
    end
  end

  def update_southeast_corner(coord, manhattan_dist = 2)
    return if distance_too_small?(manhattan_dist, 2)
    (1...manhattan_dist).each do |height|
      offset = manhattan_dist - height
      update_south_column(coord.east(offset), height)
    end
  end

  def update_southwest_corner(coord, manhattan_dist = 2)
    return if distance_too_small?(manhattan_dist, 2)
    (1...manhattan_dist).each do |height|
      offset = manhattan_dist - height
      update_south_column(coord.west(offset), height)
    end
  end

  def update_northeast(coord, distance = 1)
    return if distance_too_small?(distance, 1)
    coord_NE = coord.north(distance).east(distance)
    turn_pixel_on(coord_NE)
  end

  def update_northwest(coord, distance = 1)
    return if distance_too_small?(distance, 1)
    coord_NE = coord.north(distance).west(distance)
    turn_pixel_on(coord_NE)
  end

  def update_southeast(coord, distance = 1)
    return if distance_too_small?(distance, 1)
    coord_SE = coord.south(distance).east(distance)
    turn_pixel_on(coord_SE)
  end

  def update_southwest(coord, distance = 1)
    return if distance_too_small?(distance, 1)
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

  def distance_too_small?(d, required)
    d < required
  end

  def update_columns(coord, radius)
    update_north_column(coord, radius)
    update_south_column(coord, radius)
    update_east_row(coord, radius)
    update_west_row(coord, radius)
  end

  def update_corners(coord, radius)
    update_northwest_corner(coord, radius)
    update_northeast_corner(coord, radius)
    update_southeast_corner(coord, radius)
    update_southwest_corner(coord, radius)
  end

  def update_NSEW(coord, distance)
    update_north(coord, distance)
    update_south(coord, distance)
    update_east(coord, distance)
    update_west(coord, distance)
  end
end
