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
    let(:arr_3x3) {[
      [0, 0, 0],
      [0, 1, 0],
      [0, 0, 1]
    ]}

    let(:blurred) {[
      [0, 1, 0],
      [1, 1, 1],
      [0, 1, 1]
    ]}

    let(:coordinates) { [[1, 1], [2, 2]] }
    let(:first_coordinate) { coordinates[0] }
    before(:each) { @image_3x3 = Image.new(arr_3x3) }

    describe '#blur' do
      before(:each) { @coordinate_count = coordinates.size }

      it "should call #pixel_coordinates" do
        expect(@image_3x3).to receive(:pixel_coordinates) {coordinates}
        @image_3x3.blur
      end

      it "should call #update_coordinate_sides #{@coordinate_count} times" do
        expect(@image_3x3).to receive(:update_coordinate_sides).exactly(@coordinate_count).times {coordinates}
        @image_3x3.blur
      end

      it "should blur the array correctly" do
        @image_3x3.blur
        expect(@image_3x3.image_array).to eq(blurred)
      end
    end

    describe '#pixel_coordinates' do
      it 'should find the correct pixel coordinates' do
        expect(@image_3x3.pixel_coordinates).to eq(coordinates)
      end
    end

    describe '#update_coordinate_sides' do
      it "should call #update_north, #update_east, #update_south, #update_west" do
        expect(@image_3x3).to receive(:update_north) {coordinates}
        expect(@image_3x3).to receive(:update_east) {coordinates}
        expect(@image_3x3).to receive(:update_south) {coordinates}
        expect(@image_3x3).to receive(:update_west) {coordinates}
        @image_3x3.update_coordinate_sides(first_coordinate)
      end
    end

    context "updating pixels" do
      let(:first_row) { first_coordinate[0] }
      let(:first_col) { first_coordinate[1] }

      describe '#update_north' do
        let(:blur_0_1_array) {[
            [0, 1, 0],
            [0, 1, 0],
            [0, 0, 1]
          ]}

        it "should call #in_bounds? on coordinate" do
          expect(@image_3x3).to receive(:in_bounds?) { first_coordinate }
          @image_3x3.update_north(first_row, first_col)
        end

        it "should blur the 1st row, 2nd pixel" do
          @image_3x3.update_north(first_row, first_col)
          expect(@image_3x3.image_array).to eq(blur_0_1_array)
        end
      end

      describe '#update_east' do
        let(:blur_1_2_array) {[
            [0, 0, 0],
            [0, 1, 1],
            [0, 0, 1]
          ]}

        it "should call #in_bounds? on coordinate" do
          expect(@image_3x3).to receive(:in_bounds?) { first_coordinate }
          @image_3x3.update_east(first_row, first_col)          
        end

        it "should blur the 2nd row, 3rd pixel" do
          @image_3x3.update_east(first_row, first_col)
          expect(@image_3x3.image_array).to eq(blur_1_2_array)
        end        
      end

      describe '#update_south' do
        let(:blur_2_1_array) {[
            [0, 0, 0],
            [0, 1, 0],
            [0, 1, 1]
          ]}

        it "should call #in_bounds? on coordinate" do
          expect(@image_3x3).to receive(:in_bounds?) { first_coordinate }
          @image_3x3.update_south(first_row, first_col)          
        end

        it "should blur the 3rd row, 2nd pixel" do
          @image_3x3.update_south(first_row, first_col)
          expect(@image_3x3.image_array).to eq(blur_2_1_array)
        end        
      end

      describe '#update_west' do
        let(:blur_1_0_array) {[
            [0, 0, 0],
            [1, 1, 0],
            [0, 0, 1]
          ]}

        it "should call #in_bounds? on coordinate" do
          expect(@image_3x3).to receive(:in_bounds?) { first_coordinate }
          @image_3x3.update_west(first_row, first_col)          
        end

        it "should blur the 2nd row, 1st pixel" do
          @image_3x3.update_west(first_row, first_col)
          expect(@image_3x3.image_array).to eq(blur_1_0_array)
        end        
      end      
    end

    describe '#in_bounds?' do
      let(:valid_row) { coordinates[0][0] }
      let(:valid_col) { coordinates[0][1] }

      context "valid coordinate" do
        it "should return true" do
          expect(@image_3x3.in_bounds?(valid_row, valid_col)).to be true
        end
      end

      context "invalid coordinate" do
        let(:positive_invalid_row) { arr_3x3.size }
        let(:positive_invalid_col) { arr_3x3[0].size }
        neggative_invalid_col = -1
        neggative_invalid_row = -1

        context "invalid rows" do
          it "should return false" do
            expect(@image_3x3.in_bounds?(neggative_invalid_row, valid_col)).to be false
            expect(@image_3x3.in_bounds?(positive_invalid_row, valid_col)).to be false
          end
        end

        context "invalid columns" do
          it "shoud return false" do
            expect(@image_3x3.in_bounds?(valid_row, neggative_invalid_col)).to be false
            expect(@image_3x3.in_bounds?(valid_row, positive_invalid_col)).to be false
          end
        end
      end
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
end
