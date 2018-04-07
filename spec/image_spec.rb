require "spec_helper"
require_relative "../lib/image"

RSpec.describe Image do
  describe '#initialize' do
    it "does not return nil" do
      image = Image.new([])

      expect(image).to_not be_nil
    end

    it "throws an error if no array is provided" do
      expect { Image.new }.to raise_error(ArgumentError)
    end

    it "sets 'image_array' to the array it's initialized with" do
      image = Image.new([1,2])

      result = image.image_array

      expect(result).to eq([1,2])
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

  describe '#blur' do
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

        image.blur

        expect(image.image_array).to eq(blurred_array)
      end
    end

    context 'with a distance of 2' do
      context 'and a single center pixel' do
        it "should blur the array correctly" do
          normal_array = [
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 1, 0, 0],
            [0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0]
          ]

          blurred_array = [
            [0, 0, 1, 0, 0],
            [0, 1, 1, 1, 0],
            [1, 1, 1, 1, 1],
            [0, 1, 1, 1, 0],
            [0, 0, 1, 0, 0]
          ]
          image = Image.new(normal_array)
          distance = 2

          image.blur(distance)

          expect(image.image_array).to eq(blurred_array)
        end
      end

      context 'and multiple pixels' do
        it 'should blur the array correctly' do
          normal_array = [
            [0, 0, 0, 0, 0, 0 ,0],
            [0, 0, 0, 0, 0, 0 ,0],
            [0, 0, 1, 0, 0, 0 ,0],
            [0, 0, 0, 1, 0, 0 ,0],
            [0, 0, 0, 0, 0, 0 ,0],
            [0, 0, 0, 0, 0, 0 ,1],
            [1, 0, 0, 0, 0, 0 ,0]
          ]

          blurred_array = [
            [0, 0, 1, 0, 0, 0 ,0],
            [0, 1, 1, 1, 0, 0 ,0],
            [1, 1, 1, 1, 1, 0 ,0],
            [0, 1, 1, 1, 1, 1 ,1],
            [1, 0, 1, 1, 1, 1 ,1],
            [1, 1, 0, 1, 1, 1 ,1],
            [1, 1, 1, 0, 0, 1 ,1]
          ]
          image = Image.new(normal_array)
          distance = 2

          image.blur(distance)

          expect(image.image_array).to eq(blurred_array)          
        end
      end
    end

    context 'with a distance of 3' do
      context 'and a single center pixel' do
        it "should blur the array correctly" do
          normal_array = [
            [0, 0, 0, 0, 0, 0 ,0],
            [0, 0, 0, 0, 0, 0 ,0],
            [0, 0, 0, 0, 0, 0 ,0],
            [0, 0, 0, 1, 0, 0 ,0],
            [0, 0, 0, 0, 0, 0 ,0],
            [0, 0, 0, 0, 0, 0 ,0],
            [0, 0, 0, 0, 0, 0 ,0]
          ]

          blurred_array = [
            [0, 0, 0, 1, 0, 0 ,0],
            [0, 0, 1, 1, 1, 0 ,0],
            [0, 1, 1, 1, 1, 1 ,0],
            [1, 1, 1, 1, 1, 1 ,1],
            [0, 1, 1, 1, 1, 1 ,0],
            [0, 0, 1, 1, 1, 0 ,0],
            [0, 0, 0, 1, 0, 0 ,0]
          ]
          image = Image.new(normal_array)
          distance = 3

          image.blur(distance)

          expect(image.image_array).to eq(blurred_array)
        end
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
        Coordinate.new(0, 0),
        Coordinate.new(1, 0),
        Coordinate.new(1, 2),
        Coordinate.new(2, 1)
      ]
      image = Image.new(normal_array)

      pixels_found = image.pixel_coordinates

      expect(pixels_found).to eq(pixels)
    end
  end

  describe '#update_north_west' do
    context 'with distance of 1' do
      it 'should change the NW pixel to 1' do
        normal_array = [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0]
        ]
        expected_array = [
          [1, 0, 0],
          [0, 1, 0],
          [0, 0, 0]
        ]        
        row = 1
        col = 1
        image = Image.new(normal_array)
        coord = Coordinate.new(row, col)

        image.update_north_west(coord)

        expect(image.image_array).to eq(expected_array)      
      end
    end

    context 'with distance of 2' do
      it 'should change the NW pixel (diagonally 2 away) to 1' do
        normal_array = [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
        expected_array = [
          [1, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
        row = 2
        col = 2
        distance = 2
        image = Image.new(normal_array)
        coord = Coordinate.new(row, col)

        image.update_north_west(coord, distance)

        expect(image.image_array).to eq(expected_array)      
      end
    end    
  end

  describe '#update_north_east' do
    context 'with distance of 1' do
      it 'should change the NE pixel to 1' do
        normal_array = [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0]
        ]
        expected_array = [
          [0, 0, 1],
          [0, 1, 0],
          [0, 0, 0]
        ]        
        row = 1
        col = 1
        image = Image.new(normal_array)
        coord = Coordinate.new(row, col)

        image.update_north_east(coord)

        expect(image.image_array).to eq(expected_array)      
      end
    end

    context 'with distance of 2' do
      it 'should change the NE pixel (diagonally 2 away) to 1' do
        normal_array = [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
        expected_array = [
          [0, 0, 0, 0, 1],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
        row = 2
        col = 2
        distance = 2
        image = Image.new(normal_array)
        coord = Coordinate.new(row, col)

        image.update_north_east(coord, distance)

        expect(image.image_array).to eq(expected_array)      
      end
    end    
  end

  describe '#update_south_east' do
    context 'with distance of 1' do
      it 'should change the SE pixel to 1' do
        normal_array = [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0]
        ]
        expected_array = [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 1]
        ]        
        row = 1
        col = 1
        image = Image.new(normal_array)
        coord = Coordinate.new(row, col)

        image.update_south_east(coord)

        expect(image.image_array).to eq(expected_array)      
      end
    end

    context 'with distance of 2' do
      it 'should change the SE pixel (diagonally 2 away) to 1' do
        normal_array = [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
        expected_array = [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 1]
        ]
        row = 2
        col = 2
        distance = 2
        image = Image.new(normal_array)
        coord = Coordinate.new(row, col)

        image.update_south_east(coord, distance)

        expect(image.image_array).to eq(expected_array)      
      end
    end    
  end

  describe '#update_south_west' do
    context 'with distance of 1' do
      it 'should change the SW pixel to 1' do
        normal_array = [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0]
        ]
        expected_array = [
          [0, 0, 0],
          [0, 1, 0],
          [1, 0, 0]
        ]        
        row = 1
        col = 1
        image = Image.new(normal_array)
        coord = Coordinate.new(row, col)

        image.update_south_west(coord)

        expect(image.image_array).to eq(expected_array)      
      end
    end

    context 'with distance of 2' do
      it 'should change the SW pixel (diagonally 2 away) to 1' do
        normal_array = [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ]
        expected_array = [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 1, 0, 0],
          [0, 0, 0, 0, 0],
          [1, 0, 0, 0, 0]
        ]
        row = 2
        col = 2
        distance = 2
        image = Image.new(normal_array)
        coord = Coordinate.new(row, col)

        image.update_south_west(coord, distance)

        expect(image.image_array).to eq(expected_array)      
      end
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
      coord = Coordinate.new(row, col)

      image.update_north(coord)

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
      coord = Coordinate.new(row, col)

      image.update_north(coord, distance)

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
      coord = Coordinate.new(row, col)

      image.update_south(coord)

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
      coord = Coordinate.new(row, col)

      image.update_south(coord, distance)

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
      coord = Coordinate.new(row, col)

      image.update_east(coord)

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
      coord = Coordinate.new(row, col)

      image.update_east(coord, distance)

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
      coord = Coordinate.new(row, col)

      image.update_west(coord)

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
      coord = Coordinate.new(row, col)

      image.update_west(coord, distance)

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
        coord = Coordinate.new(row, col)

        image.turn_pixel_on(coord)

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
        coord = Coordinate.new(row, col)

        image.turn_pixel_on(coord)

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
        coord = Coordinate.new(row, col)

        expect(image.in_bounds?(coord)).to be true
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
        coord = Coordinate.new(row, col)

        expect(image.in_bounds?(coord)).to be false
      end
    end
  end

  describe '#pixel_off?' do
    it 'should return true if coordinate == 0' do
      normal_array = [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
      ]
      row = 1
      col = 0
      image = Image.new(normal_array)
      coord = Coordinate.new(row, col)

      expect(image.pixel_off?(coord)).to be true
    end

    it 'should return false if coordinate == 1' do
      normal_array = [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
      ]
      row = 1
      col = 1
      image = Image.new(normal_array)
      coord = Coordinate.new(row, col)

      expect(image.pixel_off?(coord)).to be false
    end

    it 'shoult return false if coordinate is out of bounds' do
      normal_array = [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
      ]
      row = 1
      col = 1
      image = Image.new(normal_array)
      coord = Coordinate.new(row, col)

      expect(image.pixel_off?(coord)).to be false      
    end
  end
end
