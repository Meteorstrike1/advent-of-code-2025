# Had recently discovered max_by and wanted to use it
# Part 1, two highest values in row (can't rearrange order), did try iterating through second half of array before realising could just use max_by for both values
# Part 2 needed to find 12 highest values (can't rearrange order), was worried about running into a time problem but could make original approach work for 12 too

filename = 'inputday3'
file = File.readlines(filename, chomp: true)

banks = file.map do |bank|
  bank.split('').map(&:to_i)
end

# Part 1
def find_highest_joltage(bank)
  # Check from start of array to one from last for max value
  left_value = bank[0..-2].max_by { |value| value }
  index = bank.index(left_value)
  # Check from value after highest to end of array for next max value
  right_value = bank[index + 1..].max_by { |value| value }
  (left_value.to_s + right_value.to_s).to_i
end

# List of highest joltage per bank
highest_joltages = banks.map do |bank|
  find_highest_joltage(bank)
end

# Total
part1 = highest_joltages.reduce(:+)

puts "Part 1: #{part1}"

# Part 2
def find_n_highest_joltage(bank, num_batteries)
  highest_joltages = []
  left_idx = 0
  right_idx = num_batteries
  # Repeat for amount of batteries adding together
  num_batteries.times do
    # If on last battery, search to end of list (-0 will give nil)
    if right_idx.zero?
      joltage = bank[left_idx..].max_by { |value| value }
      # Couldn't figure out a way of getting the highest value and index at the same time
      # (Index is zoned in to the current search size so need to add unsearched size too)
      index = bank[left_idx..].each_index.max_by { |i| bank[left_idx..][i] } + left_idx
    else
      # Searching between left index and last so many values
      joltage = bank[left_idx..-right_idx].max_by { |value| value }
      index = bank[left_idx..-right_idx].each_index.max_by { |i| bank[left_idx..-right_idx][i] } + left_idx
    end
    # Set left index to value after current highest
    left_idx = index + 1
    # Reduce right index by 1 because can search closer to end as fewer batteries remain
    right_idx -= 1
    highest_joltages << joltage.to_s
  end
  highest_joltages
end

# Could use part 2 solution for part 1 as well by passing in 2
highest_12_joltages = banks.map do |bank|
  highest = find_n_highest_joltage(bank, 12)
  highest.join('').to_i
end

# Total
part2 = highest_12_joltages.reduce(:+)

puts "Part 2: #{part2}"
