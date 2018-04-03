# require_relative "./image_blur/version"
require "pry"

class Image
  attr_reader :image_array

  def initialize(image_array)
    @image_array = image_array
    # @blurred_image = image_array.map(&:clone)
    # @num_of_rows = image_array.length
  end

  def output_image
    image_array.each do |row|
      puts row.join
    end
  end

  def blur
    pixel_coordinates.each do |coordinate|
      update_north(coordinate)
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

  def update_north(coordinate)
    row, col = coordinate
    in_bounds?(row, col)
  end

  def in_bounds?(row, col)
    true
  end
end