require_relative 'safe'
# Part 1 tried to solve just with indexing, couldn't get enumerable working
# Part 2 was stuck for a while, refactored and used two enumerables, one for each direction (pretty messy)

filename = 'inputday1'

# Safe combinations e.g. [L29, R31, etc]
combinations = File.readlines(filename, chomp: true)

# Part 1
numbers = (0..99).to_a
current_position = 50

NUM_VALUES = 100

# Rotate to new position
def rotate(current_position, rotation, numbers)
  direction = rotation.scan(/[LR]/).first
  distance = rotation.scan(/\d+/).first.to_i
  case direction
  when 'L'
    numbers[calculate_position(current_position - distance)]
  when 'R'
    numbers[calculate_position(current_position + distance)]
  else
    raise 'Error!'
  end
end

# Calculate index of new position that doesn't go out of bounds (using negative indexing for left)
def calculate_position(difference)
  if difference >= NUM_VALUES
    difference.to_s.chars[-2..].join.to_i
  elsif difference < -NUM_VALUES
    - difference.to_s.chars[-2..].join.to_i
  else
    difference
  end
end

zeros = 0

# Loop through, each combination, count if 0
combinations.each do |combo|
  current_position = rotate(current_position, combo, numbers)
  zeros += 1 if current_position.zero?
end

puts "Part 1: #{zeros}"

# Part 2 using Safe class
safe = Safe.new

def extract_rotation(rotation)
  direction = rotation.scan(/[LR]/).first
  distance = rotation.scan(/\d+/).first.to_i
  [direction, distance]
end

combinations.each do |combo|
  direction, distance = extract_rotation(combo)
  safe.move(direction, distance)
end

puts "Part 1: #{safe.zeros}"
