require "spec_helper"
require_relative "../lib/image"

RSpec.describe Image do
  distance = 2
  if distance > 3 || distance < 1
    raise ArgumentError, "distance (#{distance}) must be set to 1 - 3"
  end

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
    let(:normal_array) {[
      [1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1],
      [1, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 1, 0],
      [1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1]
    ]}
    case distance
    when 1
      let(:blurred_array) {[
        [1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 0, 1, 1, 1, 1],
        [1, 1, 0, 0, 1, 1],
        [1, 0, 0, 0, 1, 1]
      ]}
    when 2
      let(:blurred_array) {[
        [1, 1, 1, 0, 0, 1],
        [1, 0, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 0, 1, 1, 1, 1],
        [1, 1, 1, 0, 1, 1],
        [1, 0, 0, 1, 1, 1]
      ]}
    when 3
      let(:blurred_array) {[
        [1, 1, 1, 1, 1, 1],
        [1, 0, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1],
        [1, 0, 1, 1, 1, 1]
      ]}
    end

    let(:coordinates) {[
      [0, 0],
      [1, 5],
      [2, 0],
      [2, 2],
      [3, 4],
      [4, 0],
      [5, 5]
    ]}
  
    let(:third_coordinate) { coordinates[2] }
    before(:each) { @image = Image.new(normal_array) }

    describe '#blur' do
      # this doesn't set correctly
      before(:each) { @coordinate_count = coordinates.size }

      it "should take an optional distance argument as an integer" do
        expect { @image.blur }.not_to raise_error
        expect { @image.blur(distance) }.not_to raise_error
        expect { @image.blur('a').to raise_error(ArgumentError) }
      end

      it "should set @distance to the argument given" do
        expect(@image.instance_variable_get(:@distance)).to eq(1)
        @image.blur(distance)
        expect(@image.instance_variable_get(:@distance)).to eq(distance)
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
