def part_one
  # On each line, the calibration value can be found by combining the first digit
  # and the last digit (in that order) to form a single two-digit number.
  input = File.read('day1/input.txt').split("\n")
  digits_regex = /[1234567890]/
  digits_per_line = input.map { |line| line.scan(digits_regex) }
  combined_numbers = digits_per_line
    .map { |digits| digits[0] + digits[-1] }
    .map(&:to_i)
  total = combined_numbers.sum
  puts total
end

def peek_word(word, string, index)
  word_index = 0
  while word_index < word.length
    if index + word_index >= string.length
      return false
    end
    if word[word_index] != string[index + word_index]
      return false
    end
    word_index += 1
  end
  true
end

def part_two
  input = File.read('day1/input.txt').split("\n")
  digits_regex = /[1234567890]/
  digits_per_line = []

  input.each do |line|
    index = 0
    line_digits = []
    while index < line.length
      if line[index].match(digits_regex)
        line_digits << line[index]
      elsif peek_word('one', line, index)
        line_digits << '1'
      elsif peek_word('two', line, index)
        line_digits << '2'
      elsif peek_word('three', line, index)
        line_digits << '3'
      elsif peek_word('four', line, index)
        line_digits << '4'
      elsif peek_word('five', line, index)
        line_digits << '5'
      elsif peek_word('six', line, index)
        line_digits << '6'
      elsif peek_word('seven', line, index)
        line_digits << '7'
      elsif peek_word('eight', line, index)
        line_digits << '8'
      elsif peek_word('nine', line, index)
        line_digits << '9'
      elsif peek_word('zero', line, index)
        line_digits << '0'
      end
      index += 1
    end
    digits_per_line << line_digits
  end

  combined_numbers = digits_per_line
    .map { |digits| digits[0] + digits[-1] }
    .map(&:to_i)
  total = combined_numbers.sum
  puts total
end

if __FILE__ == $0
  part_two
end