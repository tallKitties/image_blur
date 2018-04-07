<!-- MarkdownTOC -->

- [Development](#development)
- [Image](#image)
- [Usage](#usage)
    - [#image_array](#image_array)
    - [#output_image](#output_image)
    - [#pixel_coordinates](#pixel_coordinates)
    - [#blur](#blur)
- [A word of caution](#a-word-of-caution)
- [Directional update methods](#directional-update-methods)
    - [#update_north](#update_north)
    - [#update_south](#update_south)
    - [#update_east](#update_east)
    - [#update_west](#update_west)
    - [#update_north_column](#update_north_column)
    - [#update_south_column](#update_south_column)
    - [#update_east_row](#update_east_row)
    - [#update_west_row](#update_west_row)
    - [#update_northeast](#update_northeast)
    - [#update_northwest](#update_northwest)
    - [#update_southeast](#update_southeast)
    - [#update_southwest](#update_southwest)
    - [#update_northeast_corner](#update_northeast_corner)
    - [#update_northwest_corner](#update_northwest_corner)
    - [#update_southeast_corner](#update_southeast_corner)
    - [#update_southwest_corner](#update_southwest_corner)
    - [#turn_pixel_on](#turn_pixel_on)
    - [#pixel_off?](#pixel_off)
    - [#in_bounds?](#in_bounds)
- [Coordinate](#coordinate)
- [Usage](#usage-1)
    - [#row](#row)
    - [#col](#col)
    - [#coord](#coord)
    - [#north](#north)
    - [#south](#south)
    - [#east](#east)
    - [#west](#west)
- [License](#license)

<!-- /MarkdownTOC -->



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

# Image

An class to modify cells of a given 2D array.

## Usage

requires a 2D array as an argument.
```
image = Image.new([
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
])
```
#### #image_array
* the array passed as an argument in #new

#### #output_image
* will puts out @image_array in a readable format

#### #pixel_coordinates
* returns a list of [coordinates](#coordinate) for pixels already "turned on" (1's in the array).

#### #blur
* `#blur([radius = 1])`
* Finds any pixel in `@image_array` that is "on" (1). Then it changes the surrounding pixels, within a given distance, to 1. The distance is calculated as
[Manhattan Distance](https://en.wiktionary.org/wiki/Manhattan_distance), so the blur will not attempt a radial blur.

+ for example, if we called `image.blur(5)`, then `image.output_image` would produce...
```
    0 0 0 0 0 1 0 0 0 0 0
    0 0 0 0 1 1 1 0 0 0 0
    0 0 0 1 1 1 1 1 0 0 0
    0 0 1 1 1 1 1 1 1 0 0
    0 1 1 1 1 1 1 1 1 1 0
    1 1 1 1 1 1 1 1 1 1 1
    0 1 1 1 1 1 1 1 1 1 0
    0 0 1 1 1 1 1 1 1 0 0
    0 0 0 1 1 1 1 1 0 0 0
    0 0 0 0 1 1 1 0 0 0 0
    0 0 0 0 0 1 0 0 0 0 0
```

## A word of caution
* The default distance for all `update_DIRECTION` methods, is also it's minimum required. If you pass anything less than default, it will just return nil and not update it. That's because you would be trying to update the origin coordinate, which these methods are not intended to do. Please use [#turn_pixel_on](#35turn_pixel_oncoord) for that.
* This might show itself if you try to run a `.times` loop, and use the number as your distance. Since that starts at 0, you'll begin by updating your origin coordinate, and end with a distance 1 less than probably intended. Use #upto instead.

## Directional update methods
#### #update_north
* `#update_north(coord, [distance = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixel DISTANCE pixels North of the coordinate to 1
```
pixels = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
]
c = Coordinate.new(2, 1) #bottom center pixel
image = Image.new(pixels)
image.update_north(c, 2)
image.output_image

    0 1 0
    0 0 0
    0 0 0

```

#### #update_south
* `#update_south(coord, [distance = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixel DISTANCE pixels South of the coordinate to 1

#### #update_east
* `#update_east(coord, [distance = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixel DISTANCE pixels East of the coordinate to 1

#### #update_west
* `#update_west(coord, [distance = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixel DISTANCE pixels West of the coordinate to 1

#### #update_north_column
* `#update_north_column(coord, [height = 1])`
* requires a [Coordinate](#coordinate) object
* sets the column of pixels HEIGHT pixels North of the coordinate to 1
```
pixels = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
]
c = Coordinate.new(3, 1) #bottom center pixel
height = 3
image = Image.new(pixels)
image.update_north_column(c, height)
image.output_image

    0 1 0
    0 1 0
    0 1 0
    0 0 0

```

#### #update_south_column
* `#update_south_column(coord, [height = 1])`
* requires a [Coordinate](#coordinate) object
* sets the column of pixels HEIGHT pixels South of the coordinate to 1

#### #update_east_row
* `#update_east_row(coord, [width = 1])`
* requires a [Coordinate](#coordinate) object
* sets the row of pixels WIDTH pixels East of the coordinate to 1

#### #update_west_row
* `#update_west_row(coord, [width = 1])`
* requires a [Coordinate](#coordinate) object
* sets the row of pixels WIDTH pixels West of the coordinate to 1

#### #update_northeast
* `(coord, [distance = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixel diagonally DISTANCE pixels to the North East to 1
```
pixels = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
]
c = Coordinate.new(2, 0) #bottom left pixel
image = Image.new(pixels)

# if we start at 0, we begin by updating the (2, 0) origin coordinate, which
# is not the intention of any update_DIRECTION method.
1.upto(2) { |d| image.update_northeast(c, d) }
image.output_image

    0 0 1
    0 1 0
    0 0 0

```

#### #update_northwest
* `(coord, [distance = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixel diagonally DISTANCE pixels to the North West to 1

#### #update_southeast
* `(coord, [distance = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixel diagonally DISTANCE pixels to the South East to 1

#### #update_southwest
* `(coord, [distance = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixel diagonally DISTANCE pixels to the South West to 1

#### #update_northeast_corner
* `#update_northeast_corner(coord, [manhattan_dist = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixels in the North East corner, within the Manhattan distance given, to 1. It does not update the north/south columns or east/west rows from the origin coordinate. This is best demonstrated, as it may not be exactly what you are expecting...
```
pixels = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0]
]
c = Coordinate.new(4, 0) #bottom left pixel
manhattan_dist = 5
image = Image.new(pixels)
image.update_northeast_corner(c, manhattan_dist)
image.output_image

    0 0 0 0 0
    0 1 0 0 0
    0 1 1 0 0
    0 1 1 1 0
    0 0 0 0 0

# if you want the corner, including the origin column/row updated, you have to
# use #update_DIRECTION_column / row for now
```

#### #update_northwest_corner
* `#update_northwest_corner(coord, [manhattan_dist = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixels in the North West corner, within the Manhattan distance given, to 1.

#### #update_southeast_corner
* `#update_southeast_corner(coord, [manhattan_dist = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixels in the South East corner, within the Manhattan distance given, to 1.

#### #update_southwest_corner
* `#update_southwest_corner(coord, [manhattan_dist = 1])`
* requires a [Coordinate](#coordinate) object
* sets the pixels in the South West corner, within the Manhattan distance given, to 1.

#### #turn_pixel_on
* `#turn_pixel_on(coord)`
* requires a [Coordinate](#coordinate) object
* sets the pixel at the given coordinate to 'on' (1)
* uses `#pixel_off?` & `#in_bounds?` first to make sure the given coordinate is within the bounds of `@image_array`, and is not needlessly turned on.

#### #pixel_off?
* `#pixel_off?(coord)`
* requires a [Coordinate](#coordinate) object
* returns true if the given coordinate is not already 'on' (1) in `@image_array`

#### #in_bounds?
* `#in_bounds?(coord)`
* requires a [Coordinate](#coordinate) object
* returns true if the coordinate is within the bounds of `@image_array`.
* in this case, 'within the bounds' refers to a coordinate that references a number starting at 0, and less than the number of rows, or less than the length of the row.
* basically, if you give it (0, -1) to reference the last column in the first row, it's not going to be in bounds.
* the same applies if you try to reference a row or column that is larger than what is in `@image_array`.

# Coordinate
* An object that makes passing around, and modifying, coordinates easier

##Usage
* Requires a row (int) and column (int)
```
c = Coordinate.new(2, 5)
c.row
    2
c.col
    5
c.coord
    {:row => 2, :col => 5}
c.north(2)
    <Coordinate:0x007fb42f1af668 @col=5, @coord={:row=>1, :col=>5}, @row=1>
```

#### #row
* returns the current row of the object

#### #col
* returns the current column of the object

#### #coord
* returns a hash of the coordinate in the form of...
```
{
    :row => @row,
    :col => @col
}
```

#### #north
* `#north([distance = 1])`
* returns a new coordinate object with the rows shifted DISTANCE rows to the North

#### #south
* `#south([distance = 1])`
* returns a new coordinate object with the rows shifted DISTANCE rows to the South

#### #east
* `#east([distance = 1])`
* returns a new coordinate object with the rows shifted DISTANCE rows to the East

#### #west
* `#west([distance = 1])`
* returns a new coordinate object with the rows shifted DISTANCE rows to the West

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
