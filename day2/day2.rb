# Part 1 just checked if left half matched right half (sequence repeated twice)
# Part 2 (sequence repeating twice or more) thought could use a matching algorithm, tried a KMP one that looks for repeated words
# Answer was too high so then searched for a hint and found out about self-referring backreference regex...

filename = 'inputday2'
ranges = File.read(filename).split('')

RANGE_REGEX = /(?<start>\d+)-(?<end>\d+)/

# Part 1
def is_even_length?(num)
  num.to_s.chars.length.even?
end

def repeated_sequence?(num)
  if is_even_length?(num)
    left, right = num.to_s.chars.each_slice(num.to_s.chars.length / 2).to_a
    left.join.to_i == right.join.to_i
  else
    false
  end
end

repeated_sequences = []

ranges.each do |range|
  captures = range.match(RANGE_REGEX).named_captures
  start_num = captures['start']
  end_num = captures['end']
  # Ignore not an ID (starts with a leading zero)
  next if (start_num[0] == '0' && start_num.length > 1) || (end_num[0] == '0' && end_num.length > 1)

  (start_num.to_i..end_num.to_i).to_a.each do |num|
    repeated_sequences << num if repeated_sequence?(num)
  end
end

part1 = repeated_sequences.reduce(:+)

puts "Part 1: #{part1}"

# Part 2
REPEAT_REGEX = /^(\d+)\1+$/
TWICE_REGEX = /^(\d+)\1$/ # Didn't use this but this would have worked for part 1 in solution below

more_than_twice_sequences = []

ranges.each do |range|
  captures = range.match(RANGE_REGEX).named_captures
  start_num = captures['start']
  end_num = captures['end']
  (start_num.to_i..end_num.to_i).to_a.each do |num|
    more_than_twice_sequences << num if num.to_s.match?(REPEAT_REGEX)
  end
end

part2 = more_than_twice_sequences.reduce(:+)

puts "Part 2: #{part2}"

