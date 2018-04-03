require "spec_helper"
require_relative "../lib/image"

RSpec.describe Image do
  describe '#initialize' do
    it "gives an 'Image' when created" do
      # arrange / act
      image = Image.new([])

      # assert
      expect(image).to_not be_nil
    end

    it "sets 'image_array' to the array it's initialized with" do
      # arrange
      image = Image.new([1,2])

      # act
      result = image.image_array

      # assert
      expect(result).to eq([1,2])
    end

    it "throws an error if no array is provided" do
      # arrange / act / assert
      expect { Image.new }.to raise_error(ArgumentError)
    end
  end

  describe '#output_image' do
    # arrange
    let(:image_array) {[
      [0,0,0,1],
      [0,0,1,0],
      [0,1,0,0],
      [1,0,0,0]
    ]}
    let(:image) { Image.new(image_array)}

    it "should print out each subarry as a string on a new line" do
      # assert
      image_array.each do |sub_arr|
        allow(image).to receive(:puts).with(sub_arr.join)
      end

      # act
      image.output_image
    end
  end

  context 'with basic array' do
    arr_3x3 = [
      [0, 0, 0],
      [0, 1, 0],
      [0, 0, 1]
    ]
    coordinates = [[1, 1], [2, 2]]
    image_3x3 = Image.new(arr_3x3)

    describe '#blur' do
      it 'should call #pixel_coordinates' do
        expect(image_3x3).to receive(:pixel_coordinates)
        image_3x3.blur
      end

      # it "should blur pixels right & left of the center pixel" do
      #   # arrange
      #   center_pixel_array = [
      #     [0, 0, 0, 0, 0],
      #     [0, 0, 0, 0, 0],
      #     [0, 0, 1, 1, 0],
      #     [0, 0, 0, 0, 0],
      #     [0, 0, 0, 0, 0]
      #   ]
      #   blurred_array = [
      #     [0, 0, 0, 0, 0],
      #     [0, 0, 0, 0, 0],
      #     [0, 1, 1, 1, 1],
      #     [0, 0, 0, 0, 0],
      #     [0, 0, 0, 0, 0]
      #   ]
      #   center_image = Image.new(center_pixel_array)

        # act

        # assert
        # expect(center_image.blurred_image).to eq(blurred_array)
      # end

      # it "should blur top/right/bottom/left pixels of [1][3] & [3][1] pixels" do
      #   # arrange
      #   multi_pixel_array = [
      #     [0,0,0,0,0],
      #     [0,0,0,1,0],
      #     [0,0,0,0,0],
      #     [0,1,0,0,0],
      #     [0,0,0,0,0]
      #   ]
      #   multi_image = Image.new(multi_pixel_array)
      # end

      # it "should blur the pixel to the right of the [3][0] pixel" do
      #   # arrange
      #   edge_pixel_array = [
      #     [0,0,0,0,0],
      #     [0,0,0,0,0],
      #     [0,0,0,0,0],
      #     [1,0,0,0,0],
      #     [0,0,0,0,0]
      #   ]
      #   blurred_array = [
      #     [0,0,0,0,0],
      #     [0,0,0,0,0],
      #     [0,0,0,0,0],
      #     [1,1,0,0,0],
      #     [0,0,0,0,0]
      #   ]
      #   edge_image = Image.new(edge_pixel_array)

      #   # act
      #   edge_image.blur_image

      #   # assert
      #   expect(edge_image.blurred_image).to eq(blurred_array)
      # end
    end

    describe '#pixel_coordinates' do
      it 'should find the correct pixel coordinates' do
        expect(image_3x3.pixel_coordinates).to eq(coordinates)
      end
    end
  end
end
