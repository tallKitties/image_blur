require "image_blur"

RSpec.describe ImageBlur do
  describe '#initialize' do
    it "gives an 'Image' when created" do
      expect(Image.new([])).to be_an(Image)
    end

    it "sets 'image_array' to the array it's initialized with" do
      image = Image.new([1,2])
      expect(image.image_array).to eq([1,2])
    end

    it "throws un error if no array is provided" do
      expect { Image.new }.to raise_error(ArgumentError)
    end
  end

  describe '#output_image' do
    let(:image_array) {[
      [0,0,0,1],
      [0,0,1,0],
      [0,1,0,0],
      [1,0,0,0]
    ]}
    let(:image) { Image.new(image_array)}

    it "should print out each subarry as a string on a new line" do
      image_array.each do |sub_arr|
        allow(image).to receive(:puts).with(sub_arr.join)
      end
      image.output_image
    end
  end
end
