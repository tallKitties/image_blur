# require_relative "./image_blur/version"
require "pry"

class Image
  attr_reader :image_array

  def initialize(image_array)
    @image_array = image_array
    @distance = 1
  end

  def output_image
    image_array.each do |row|
      puts row.join
    end
  end

  def blur(distance = nil)
    @distance = distance.nil? ? @distance : distance + 0
    pixel_coordinates.each do |pixel|
      update_sides_of_coordinate(pixel)
    end
  end

  private

  def pixel_coordinates
    coordinates = []
    image_array.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        coordinates << [row_index, cell_index] if cell == 1
      end
    end
    coordinates
  end

  def update_sides_of_coordinate(pixel)
    row, col = pixel
    @distance.downto(1) do |d|
      coordinates_to_update(d, pixel).each do |c|
        turn_pixel_on(c[0], c[1])
      end
      # update_north(row, col)
      # update_east(row, col)
      # update_south(row, col)
      # update_west(row, col)
    end
  end

  def coordinates_to_update(distance, pixel)
    row, col = pixel
    # north, east, south, west
    [
      [row - distance, col],
      [row, col + distance],
      [row + distance, col],
      [row, col - distance]
    ]
  end

  def update_north(row, col)
    turn_pixel_on(row - 1, col)
  end

  def update_east(row, col)
    turn_pixel_on(row, col + 1)
  end

  def update_south(row, col)
    turn_pixel_on(row + 1, col)
  end

  def update_west(row, col)
    turn_pixel_on(row, col - 1)
  end

  def in_bounds?(row, col)
    (0..image_array.size - 1).cover?(row) && (0..image_array[row].size - 1).cover?(col)
  end

  def turn_pixel_on(row, col)
    image_array[row][col] = 1 if in_bounds?(row, col)
  end
end