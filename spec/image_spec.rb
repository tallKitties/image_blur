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

      it "should take an optional distance argument as an integer" do
        expect { @image.blur }.not_to raise_error
        expect { @image.blur(distance) }.not_to raise_error
        expect { @image.blur('a').to raise_error(ArgumentError) }
      end

      it "should blur the array correctly" do
        @image.blur(distance)
        expect(@image.image_array).to eq(blurred_array)
      end
    end

    describe '#pixel_coordinates' do
      it 'should find the correct pixel coordinates' do
        expect(@image.pixel_coordinates).to eq(coordinates)
      end
    end

    context "while updating a single pixel coordinate" do
      let(:row) { third_coordinate[0] }
      let(:col) { third_coordinate[1] }

      describe '#turn_pixel_on' do
        it "should change pixel to 1" do
          row_above = row - 1
          col_right = col + 1
          expect(@image.turn_pixel_on(row_above, col_right)).not_to be_nil
        end

        it "should not update an out of bound coordinate" do
          out_of_bounds_row = -1
          out_of_bounds_col = -1
          expect(@image.turn_pixel_on(out_of_bounds_row, col)).to be_nil
          expect(@image.turn_pixel_on(row, out_of_bounds_col)).to be_nil
        end
      end
    end
  end
end
