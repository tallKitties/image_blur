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

  context 'blurring an image' do
    let(:distance) { 1 }

    let(:normal_array) {[
      [1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [1, 0, 1, 0, 0],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0]
    ]}

    let(:blurred_array) {[
      [1, 1, 0, 0, 0],
      [1, 0, 1, 0, 0],
      [1, 1, 1, 1, 1],
      [1, 0, 1, 1, 1],
      [0, 0, 0, 0, 1]
    ]}

    let(:coordinates) {[
      [0, 0],
      [2, 0],
      [2, 2],
      [3, 4]
    ]}
  
    let(:third_coordinate) { coordinates[2] }
    before(:each) { @image = Image.new(normal_array) }

    describe '#blur' do
      # this doesn't set correctly
      before(:each) { @coordinate_count = coordinates.size }

      it "should take an optional distance argument (integer)" do
        expect { @image.blur }.not_to raise_error
        expect { @image.blur(distance) }.not_to raise_error
        expect { @image.blur('a').to raise_error(ArgumentError) }
      end

      it "should call #pixel_coordinates" do
        expect(@image).to receive(:pixel_coordinates) { coordinates }
        @image.blur(distance)
      end

      it "should call #update_sides_of_coordinate #{@coordinate_count} times" do
        expect(@image).to receive(:update_sides_of_coordinate).exactly(@coordinate_count).times { coordinates }
        @image.blur(distance)
      end

      it "should blur the array correctly" do
        @image.blur(distance)
        expect(@image.image_array).to eq(blurred_array)
      end
    end
  end
end
