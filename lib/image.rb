# require_relative "./image_blur/version"
require 'pry'

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

  def blur_NSEW(distance = 1)
    pixel_coordinates.each do |pixel_coord|
      distance.downto(1) do |d|
        update_NSEW(pixel_coord, d)
      end
    end
  end

  def pixel_coordinates
    coordinates = []
    image_array.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        coordinates << [row_index, cell_index] if cell == 1
      end
    end
    coordinates
  end

  def update_north(row, col, distance = 1)
    turn_pixel_on(row - distance, col)
  end

  def update_south(row, col, distance = 1)
    turn_pixel_on(row + distance, col)
  end

  def update_east(row, col, distance = 1)
    turn_pixel_on(row, col + distance)
  end

  def update_west(row, col, distance = 1)
    turn_pixel_on(row, col - distance)
  end      

  def turn_pixel_on(row, col)
    image_array[row][col] = 1 if in_bounds?(row, col)
  end

  def in_bounds?(row, col)
    (0...image_array.size).cover?(row) &&
      (0...image_array[row].size).cover?(col)
  end

  private

  def update_NSEW(pixel_coord, distance)
    row, col = pixel_coord
    update_north(row, col, distance)
    update_south(row, col, distance)
    update_east(row, col, distance)
    update_west(row, col, distance)
  end
end
