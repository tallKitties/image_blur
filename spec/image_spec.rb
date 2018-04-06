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

  describe '#blur_NSEW' do
    context 'with a default distance (1)' do
      it "should blur the array correctly" do
        normal_array = [
          [1, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 1],
          [1, 0, 1, 0, 0, 0],
          [0, 0, 0, 0, 1, 0],
          [1, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 1]
        ]

        blurred_array = [
          [1, 1, 0, 0, 0, 1],
          [1, 0, 1, 0, 1, 1],
          [1, 1, 1, 1, 1, 1],
          [1, 0, 1, 1, 1, 1],
          [1, 1, 0, 0, 1, 1],
          [1, 0, 0, 0, 1, 1]
        ]
        image = Image.new(normal_array)

        image.blur_NSEW

        expect(image.image_array).to eq(blurred_array)
      end
    end

    context 'with a distance of 2' do
      it "should blur the array correctly" do
        normal_array = [
          [1, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 1],
          [1, 0, 1, 0, 0, 0],
          [0, 0, 0, 0, 1, 0],
          [1, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 1]
        ]

        blurred_array = [
          [1, 1, 1, 0, 0, 1],
          [1, 0, 1, 1, 1, 1],
          [1, 1, 1, 1, 1, 1],
          [1, 0, 1, 1, 1, 1],
          [1, 1, 1, 0, 1, 1],
          [1, 0, 0, 1, 1, 1]
        ]
        image = Image.new(normal_array)
        distance = 2

        image.blur_NSEW(distance)

        expect(image.image_array).to eq(blurred_array)
      end
    end
  end

  describe '#pixel_coordinates' do
    it 'should return the correct pixel coordinates' do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      pixels = [
        [0, 0],
        [1, 0],
        [1, 2],
        [2, 1]
      ]
      image = Image.new(normal_array)

      pixels_found = image.pixel_coordinates

      expect(pixels_found).to eq(pixels)
    end
  end

  describe '#update_north' do
    it "should change the North pixel to 1" do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      row = 2
      col = 1
      image = Image.new(normal_array)

      image.update_north(row, col)

      expect(image.image_array[row - 1][col]).to eq(1)
    end

    it "should change the pixel 2 rows North to 1" do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      row = 2
      col = 1
      distance = 2
      image = Image.new(normal_array)

      image.update_north(row, col, distance)

      expect(image.image_array[row - distance][col]).to eq(1)
    end
  end

  describe '#update_south' do
    it "should change the South pixel to 1" do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      row = 0
      col = 1
      image = Image.new(normal_array)

      image.update_south(row, col)

      expect(image.image_array[row + 1][col]).to eq(1)        
    end

    it "should change the pixel 2 rows South to 1" do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      row = 0
      col = 2
      distance = 2
      image = Image.new(normal_array)

      image.update_south(row, col, distance)

      expect(image.image_array[row + distance][col]).to eq(1)
    end
  end

  describe '#update_east' do
    it "should change the East pixel to 1" do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      row = 1
      col = 0
      image = Image.new(normal_array)

      image.update_east(row, col)

      expect(image.image_array[row][col + 1]).to eq(1)
    end

    it "should change the pixel 2 rows East to 1" do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      row = 0
      col = 0
      distance = 2
      image = Image.new(normal_array)

      image.update_east(row, col, distance)

      expect(image.image_array[row][col + distance]).to eq(1)
    end
  end

  describe '#update_west' do
    it "should change the West pixel to 1" do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      row = 1
      col = 2
      image = Image.new(normal_array)

      image.update_west(row, col)

      expect(image.image_array[row][col - 1]).to eq(1)
    end

    it "should change the pixel 2 rows West to 1" do
      normal_array = [
        [1, 0, 0],
        [1, 0, 1],
        [0, 1, 0]
      ]
      row = 2
      col = 2
      distance = 2
      image = Image.new(normal_array)

      image.update_west(row, col, distance)

      expect(image.image_array[row][col - distance]).to eq(1)
    end
  end

  describe '#turn_pixel_on' do
    context 'with valid coordinates' do
      it 'should change pixel to 1' do
        normal_array = [
          [1, 0, 0],
          [1, 0, 1],
          [0, 1, 0]
        ]
        row = 1
        col = 1
        image = Image.new(normal_array)

        image.turn_pixel_on(row, col)

        expect(image.image_array[row][col]).to eq(1)
      end
    end

    context 'with invalid coordinates' do
      it 'should not change pixel to 1' do
        normal_array = [
          [1, 0, 0],
          [1, 0, 1],
          [0, 1, 0]
        ]
        row = 0
        col = -1
        image = Image.new(normal_array)

        image.turn_pixel_on(row, col)

        expect(image.image_array[row][col]).not_to eq(1)        
      end
    end
  end

  describe '#in_bounds?' do
    context 'with valid coordinates' do
      it 'should return true' do
        normal_array = [
          [1, 0, 0],
          [1, 0, 1],
          [0, 1, 0]
        ]
        row = 1
        col = 1
        image = Image.new(normal_array)

        expect(image.in_bounds?(row, col)).to be true
      end
    end

    context 'with invalid coordinates' do
      it 'should return false' do
        normal_array = [
          [1, 0, 0],
          [1, 0, 1],
          [0, 1, 0]
        ]
        row = 0
        col = -1
        image = Image.new(normal_array)

        expect(image.in_bounds?(row, col)).to be false
      end
    end
  end
end
