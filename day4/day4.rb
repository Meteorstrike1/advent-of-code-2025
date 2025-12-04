# Not used matrix before but used someone use it on one of the grid puzzles last year and wanted to give it a go (did copy how they formed their structure)
# Part 1 spent some time trying things out, but found it fairly straightforward
# Part 2 made into methods and looped it (used a while true before rubocop told me off for not being Ruby enough)
require 'matrix'

filename = 'inputday4'
matrix = Matrix[*File.readlines(filename, chomp: true).map(&:chars)]

HEIGHT = matrix.to_a.length
WIDTH = matrix.to_a.first.length

grid = matrix.each_with_index.with_object({}) { |(value, row, col), memo| memo[[row, col]] = value }

ROLL = '@'.freeze
SPACE = '.'.freeze

# Sure there is a much simpler way of doing this, make a list of neighbours and reject the ones that are outside the grid
def find_neighbours(row, col)
  [[row + 1, col], [row + 1, col + 1], [row, col + 1], [row - 1, col + 1], [row - 1, col], [row - 1, col - 1], [row, col - 1], [row + 1, col - 1]].reject do |arr|
    arr if arr[0].negative? || arr[0] > (HEIGHT - 1) || arr[1].negative? || arr[1] > (WIDTH - 1)
  end
end

# Part 1
accessible_rolls = []

grid.each do |coords, value|
  next unless value == ROLL

  rolls = 0
  neighbours = find_neighbours(coords[0], coords[1])
  # Go through each neighbour, check if it contains a roll, if more than 3 don't bother counting more
  neighbours.each do |neighbour|
    rolls += 1 if grid[neighbour] == ROLL
    break if rolls > 3
  end
  accessible_rolls << value unless rolls > 3
end

# Total accessible rolls (I didn't really need to make this a list)
puts "Part 1 #{accessible_rolls.count}"

# Part 2
def remove_rolls(grid, accessible_rolls)
  # If paper has been removed, replace it with a space
  accessible_rolls.each do |coord|
    grid[coord] = SPACE
  end
  grid
end

# Make iteration from part 1 reusable, save co-ordinates
def find_accessible_rolls(grid)
  accessible_rolls = []
  grid.each do |coords, value|
    next unless value == ROLL

    rolls = 0
    neighbours = find_neighbours(coords[0], coords[1])
    neighbours.each do |neighbour|
      rolls += 1 if grid[neighbour] == ROLL
      break if rolls > 3
    end
    accessible_rolls << coords unless rolls > 3
  end
  accessible_rolls
end

count = 0

# Keep searching for accessible rolls until there are no more
loop do
  more_accessible_rolls = find_accessible_rolls(grid)
  break if more_accessible_rolls.empty?

  count += more_accessible_rolls.count
  grid = remove_rolls(grid, more_accessible_rolls)
end

puts "Part 2: #{count}"
