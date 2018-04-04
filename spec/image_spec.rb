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
    let(:normal_array) {[
      [1, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [1, 0, 1, 0, 0],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 0],
    ]}

    let(:blurred_array) {[
      [1, 1, 0, 0, 0],
      [1, 0, 1, 0, 0],
      [1, 1, 1, 1, 1],
      [1, 0, 1, 1, 1],
      [0, 0, 0, 0, 1],
    ]}

    let(:coordinates) {[
      [0, 0],
      [2, 0],
      [2, 2],
      [3, 4],
    ]}
    let(:third_coordinate) { coordinates[2] }
    before(:each) { @image = Image.new(normal_array) }

    describe '#blur' do
      # this doesn't set correctly
      before(:each) { @coordinate_count = coordinates.size }

      it "should call #pixel_coordinates" do
        expect(@image).to receive(:pixel_coordinates) {coordinates}
        @image.blur
      end

      it "should call #update_coordinate_sides #{@coordinate_count} times" do
        expect(@image).to receive(:update_coordinate_sides).exactly(@coordinate_count).times {coordinates}
        @image.blur
      end

      it "should blur the array correctly" do
        @image.blur
        expect(@image.image_array).to eq(blurred_array)
      end
    end

    describe '#pixel_coordinates' do
      it 'should find the correct pixel coordinates' do
        expect(@image.pixel_coordinates).to eq(coordinates)
      end
    end

    describe '#update_coordinate_sides' do
      it "should call #update_north, #update_east, #update_south, #update_west" do
        expect(@image).to receive(:update_north) {coordinates}
        expect(@image).to receive(:update_east) {coordinates}
        expect(@image).to receive(:update_south) {coordinates}
        expect(@image).to receive(:update_west) {coordinates}
        @image.update_coordinate_sides(third_coordinate)
      end
    end

    context "while updating pixels" do
      let(:row) { third_coordinate[0] }
      let(:col) { third_coordinate[1] }

      describe '#update_north' do
        let(:modified_row) { row - 1 }

        it "should call #turn_pixel_on" do
          expect(@image).to receive(:turn_pixel_on).with(modified_row, col)
          @image.update_north(row, col)
        end

        it "should blur the specified pixel" do
          @image.update_north(row, col)
          expect(@image.image_array[modified_row][col]).to eq(1)
        end
      end

      describe '#update_east' do
        let(:modified_col) { col + 1 }

        it "should call #turn_pixel_on" do
          expect(@image).to receive(:turn_pixel_on).with(row, modified_col)
          @image.update_east(row, col)
        end

        it "should blur the specified pixel" do
          @image.update_east(row, col)
          expect(@image.image_array[col][modified_col]).to eq(1)
        end        
      end

      describe '#update_south' do
        let(:modified_row) { row + 1 }

        it "should call #turn_pixel_on" do
          expect(@image).to receive(:turn_pixel_on).with(modified_row, col)
          @image.update_south(row, col)
        end

        it "should blur the specified pixel" do
          @image.update_south(row, col)
          expect(@image.image_array[modified_row][col]).to eq(1)
        end        
      end

      describe '#update_west' do
        let(:modified_col) { col - 1 }

        it "should call #turn_pixel_on" do
          expect(@image).to receive(:turn_pixel_on).with(row, modified_col)
          @image.update_west(row, col)
        end

        it "should blur the specified pixel" do
          @image.update_west(row, col)
          expect(@image.image_array[row][modified_col]).to eq(1)
        end        
      end

      describe '#turn_pixel_on' do
        it "should call #in_bounds? on coordinate" do
          expect(@image).to receive(:in_bounds?).with(row,col)
          @image.turn_pixel_on(row, col)          
        end

        it "should change pixel to 1" do
          row_above = row - 1
          @image.turn_pixel_on(row_above, col)
          expect(@image.image_array[row_above][col]).to eq(1)
        end
      end

      describe '#in_bounds?' do
        let(:valid_row) { coordinates[0][0] }
        let(:valid_col) { coordinates[0][1] }

        context "valid coordinate" do
          it "should return true" do
            expect(@image.in_bounds?(valid_row, valid_col)).to be true
          end
        end

        context "with an invalid coordinate" do
          let(:positive_invalid_row) { normal_array.size }
          let(:positive_invalid_col) { normal_array[0].size }
          neggative_invalid_col = -1
          neggative_invalid_row = -1

          context "containing invalid rows" do
            it "should return false" do
              expect(@image.in_bounds?(neggative_invalid_row, valid_col)).to be false
              expect(@image.in_bounds?(positive_invalid_row, valid_col)).to be false
            end
          end

          context "containing invalid columns" do
            it "shoud return false" do
              expect(@image.in_bounds?(valid_row, neggative_invalid_col)).to be false
              expect(@image.in_bounds?(valid_row, positive_invalid_col)).to be false
            end
          end
        end
      end
    end
  end
end
