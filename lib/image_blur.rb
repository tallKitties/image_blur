require_relative "image_blur/version"

class Image
  attr_reader :image_array

  def initialize(image_array)
    @image_array = image_array
  end

  def output_image
    image_array.each do |sub_arr|
      puts sub_arr.join
    end
  end
  
end
