# require_relative "./image_blur/version"
require "pry"

class Image
  attr_reader :image_array, :blurred_image

  def initialize(image_array)
    @image_array = image_array
    @blurred_image = image_array.map(&:clone)
    @num_of_rows = image_array.length
  end

  def output_image(image=nil)
    image = image.nil? ? image_array : image
    image.each do |sub_arr|
      puts sub_arr.join
    end
  end

  def blur_image
    image_array.each_with_index do |row, row_index|
      pixel_indicies = get_pixels(row)

      next if pixel_indicies.empty?
      
      case row_index
      when 0
        # sides & bottom
      when 1..@num_of_rows - 2
        # sides/top/bottom
        blur_sides(row_index, row, pixel_indicies)
      when @num_of_rows - 1
        # blur_sides(row_index, row, pixel_indicies)
        # sides & top
      end
    end
  end

  private

  def blur_row(row, blur_indicies)
    row.each_with_index.map do |cell, cell_index|
      blur_indicies.include?(cell_index) ? 1 : cell
    end
  end

  def blur_sides(row_index, row, pixels)
    blur_indicies = []
    row_length = row.length - 1

    pixels.each do |pixel|
      blur_indicies << left_index(pixel) unless pixel.zero?
      blur_indicies << right_index(pixel) unless pixel == row_length
    end

    @blurred_image[row_index] = blur_row(row, blur_indicies)
  end

  def get_pixels(row)
    row.each_index.select { |cell_index| cell_index if row[cell_index] == 1 }
  end

  def left_index(pixel)
    pixel - 1
  end

  def right_index(pixel)
    pixel + 1
  end
end
