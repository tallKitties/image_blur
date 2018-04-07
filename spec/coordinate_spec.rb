require "spec_helper"
require_relative "../lib/coordinate"

RSpec.describe Coordinate do
  describe '#initialize' do
    it "does not return nil" do
      coord = Coordinate.new(0,0)

      expect(coord).to_not be_nil
    end

    it "throws an error if a row & column are not provided" do
      expect { Coordinate.new }.to raise_error(ArgumentError)
    end
  end

  describe '#row' do
    it 'should return the row provided' do
      row = 0
      col = 1
      coordinate = Coordinate.new(row, col)

      row_returned = coordinate.row

      expect(row_returned).to eq(row)
    end
  end

  describe '#col' do
    it 'should return the column provided' do
      row = 0
      col = 1
      coordinate = Coordinate.new(row, col)

      col_returned = coordinate.col

      expect(col_returned).to eq(col)
    end
  end

  describe '#coord' do
    it 'should return a correct coordinate hash' do
      row = 0
      col = 1
      coordinate = Coordinate.new(row, col)

      coord_returned = coordinate.coord

      expect(coord_returned).to eq({row: row, col: col})
    end
  end

  describe '#north_coord' do
    context 'without a distance argument' do
      it 'should return the first north coordinate' do
        row = 2
        col = 2
        distance = 1
        coordinate = Coordinate.new(row, col)
        expected_return = Coordinate.new(row - distance, col)

        coord_returned = coordinate.north

        expect(coord_returned).to eq(expected_return)
      end
    end

    context 'with a distance of 2' do
      it 'should return the coordinate 2 rows north' do
        row = 2
        col = 2
        distance = 2
        coordinate = Coordinate.new(row, col)
        expected_return = Coordinate.new(row - distance, col)

        coord_returned = coordinate.north(distance)

        expect(coord_returned).to eq(expected_return)        
      end
    end
  end

  describe '#south_coord' do
    context 'without a distance argument' do
      it 'should return the first south coordinate' do
        row = 2
        col = 2
        distance = 1
        coordinate = Coordinate.new(row, col)
        expected_return = Coordinate.new(row + distance, col)

        coord_returned = coordinate.south

        expect(coord_returned).to eq(expected_return)
      end
    end

    context 'with a distance of 2' do
      it 'should return the coordinate 2 rows south' do
        row = 2
        col = 2
        distance = 2
        coordinate = Coordinate.new(row, col)
        expected_return = Coordinate.new(row + distance, col)

        coord_returned = coordinate.south(distance)

        expect(coord_returned).to eq(expected_return)        
      end
    end
  end

  describe '#east_coord' do
    context 'without a distance argument' do
      it 'should return the first east coordinate' do
        row = 2
        col = 2
        distance = 1
        coordinate = Coordinate.new(row, col)
        expected_return = Coordinate.new(row, col + distance)

        coord_returned = coordinate.east

        expect(coord_returned).to eq(expected_return)
      end
    end

    context 'with a distance of 2' do
      it 'should return the coordinate 2 columns east' do
        row = 2
        col = 2
        distance = 2
        coordinate = Coordinate.new(row, col)
        expected_return = Coordinate.new(row, col + distance)

        coord_returned = coordinate.east(distance)

        expect(coord_returned).to eq(expected_return)        
      end
    end
  end

  describe '#west_coord' do
    context 'without a distance argument' do
      it 'should return the first west coordinate' do
        row = 2
        col = 2
        distance = 1
        coordinate = Coordinate.new(row, col)
        expected_return = Coordinate.new(row, col - distance)

        coord_returned = coordinate.west

        expect(coord_returned).to eq(expected_return)
      end
    end

    context 'with a distance of 2' do
      it 'should return the coordinate 2 columns west' do
        row = 2
        col = 2
        distance = 2
        coordinate = Coordinate.new(row, col)
        expected_return = Coordinate.new(row, col - distance)

        coord_returned = coordinate.west(distance)

        expect(coord_returned).to eq(expected_return)        
      end
    end
  end  
end
