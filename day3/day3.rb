SYMBOL_REGEX = /[0123456789\.]/
NUMBER_REGEX = /[0123456789]/

def part_one
  input = File.read('day3/input.txt').split("\n")
  part_numbers = []
  input.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      next if char.match(SYMBOL_REGEX)
      found_part_numbers = find_adjacent_numbers(input, x, y)
      puts "Found #{found_part_numbers} at #{x}, #{y} for #{char}"
      part_numbers.concat(found_part_numbers)
    end
  end
  puts part_numbers.sum
end

def find_adjacent_numbers(input, x, y)
  numbers = []
  top_numbers = []
  bottom_numbers = []

  # need to check overlapping numbers on top/bottom

  if x + 1 < input[y].length && input[y][x + 1].match(NUMBER_REGEX)
    numbers << parse_number_from_row(input, x + 1, y)
  end
  if x + 1 < input[y].length && y + 1 < input.length&& input[y + 1][x + 1].match(NUMBER_REGEX)
    bottom_numbers << parse_number_from_row(input, x + 1, y + 1)
  end
  if y + 1 < input.length && input[y + 1][x].match(NUMBER_REGEX)
    bottom_numbers << parse_number_from_row(input, x, y + 1)
  end
  if x - 1 >= 0 && y + 1 < input.length && input[y + 1][x - 1].match(NUMBER_REGEX)
    bottom_numbers << parse_number_from_row(input, x - 1, y + 1)
  end
  if x - 1 >= 0 && input[y][x - 1].match(NUMBER_REGEX)
    numbers << parse_number_from_row(input, x - 1, y)
  end
  if x - 1 >= 0 && y - 1 >= 0 && input[y - 1][x - 1].match(NUMBER_REGEX)
    top_numbers << parse_number_from_row(input, x - 1, y - 1)
  end
  if y - 1 >= 0 && input[y - 1][x].match(NUMBER_REGEX)
    top_numbers << parse_number_from_row(input, x, y - 1)
  end
  if x + 1 < input[y].length && y - 1 >= 0 && input[y - 1][x + 1].match(NUMBER_REGEX)
    top_numbers << parse_number_from_row(input, x + 1, y - 1)
  end

  numbers.concat(top_numbers.uniq)
  numbers.concat(bottom_numbers.uniq)

  numbers
end

def parse_number_from_row(input, x, y)
  start_pos = x
  end_pos = x
  while start_pos - 1 >= 0 && input[y][start_pos - 1].match(NUMBER_REGEX)
    start_pos -= 1
  end
  while end_pos + 1 < input[y].length && input[y][end_pos + 1].match(NUMBER_REGEX)
    end_pos += 1
  end
  input[y].slice(start_pos..end_pos).to_i
end

def part_two
  input = File.read('day3/input.txt').split("\n")
  part_numbers = []
  input.each_with_index do |line, y|
    line.each_char.with_index do |char, x|
      next if char != '*'
      found_part_numbers = find_adjacent_numbers(input, x, y)
      next if found_part_numbers.length != 2
      gear_ratio = found_part_numbers.reduce(:*)
      puts "Found #{found_part_numbers} at #{x}, #{y} for #{char} with ratio #{gear_ratio}"
      part_numbers << gear_ratio
    end
  end
  puts part_numbers.sum
end

if __FILE__ == $0
  part_two
end