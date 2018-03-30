# Image

An algorithm to modify cells of a 2D array that are around any given cell containing a 1.

## Usage

requires a 2D array as an argument.

image = Image.new([  
  [0,0,0],  
  [0,1,0],  
  [0,0,0]  
  ])  

@image_array
+ the array passed as an argument in #new

@blurred_image
+ the blurred version of @image_array, after #blur_image is ran

#output_image
+ will puts the given array

#blur_image
+ will change the cells to the top/right/bottom/left of any cell containing 1.
  + in the above example, @blurred_image would now be...
  + [0,1,0]
  + [1,1,1]
  + [0,1,0]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
