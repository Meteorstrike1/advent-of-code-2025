# Part 1 stripped the whitespace because why not...
# Part 2 was struggling with handling the input, did splitting into chars at first, ended up searching for hints and following an example for transposing the input

filename = 'inputday6'

# Part 1
horizontal_lines = File.readlines(filename, chomp: true)
no_components = horizontal_lines.count
last_index = no_components - 1

# Convert to integers and remove whitespace (or just remove whitespace for the signs)
converted_lines = horizontal_lines.map.with_index do |line, index|
  if index == last_index
    line.strip.split(/ +/)
  else
    line.strip.split(/ +/).map(&:to_i)
  end
end

no_inputs = converted_lines.first.count

# Grab the sign, for int arrays either add or multiply them together
def calculate(converted_lines, index)
  sign = converted_lines[-1][index]
  if sign == '+'
    converted_lines[..-2].map { |line| line[index] }.reduce(:+)
  elsif sign == '*'
    converted_lines[..-2].map { |line| line[index] }.reduce(:*)
  else
    raise 'Error!'
  end
end

total = 0

# Go through number of inputs, calculate answer and add to total
no_inputs.times do |index|
  total += calculate(converted_lines, index)
end

puts "Part 1: #{total}"

# Part 2
# Different approach to the input
file = File.readlines(filename, chomp: true).map(&:chars)
max_length = file.map(&:length).max

# Probably an easier way of doing this but was struggling with IDE stripping whitespace from input
padded_lines = file.each do |line|
  next unless line.length < max_length

  (max_length - line.length).times do
    line.append(' ')
  end
end

# Makes a single array of values e.g. ["1*", "24", "356", "", "369+", "248", "8", "", "32*", "581", "175", "", "623+", "431", "4"]
input = padded_lines.transpose.map { |arr| arr.join.delete(" ") }

total = 0

# Grab the sign, remove from value if present and convert to ints, add or multiple together
def calculate_value(split)
  sign = split[0].scan(/[+*]/).first
  split.map! do |elem|
    elem.scan(/\d+/).first
  end
  split = split.compact.map(&:to_i)
  sign == '+' ? split.reverse.reduce(:+) : split.reverse.reduce(:*)
end

split = []

# Iterate through input array
input.each_with_index do |elem, idx|
  if elem == ''
    # Add to total if segment is finished
    total += calculate_value(split)
    # Reset the sublist
    split = []
  else
    split << elem
    # For last few values don't forget to add them to total...
    total += calculate_value(split) if idx == (input.length - 1)
  end
end

puts "Part 2: #{total}"
