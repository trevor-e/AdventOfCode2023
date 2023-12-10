def part_one
  input = File.read('day9/input.txt').split("\n")
  values = input.map { |line| line.split(' ').map(&:to_i) }
  next_values = values.map { |v| find_next_value(v).map(&:last) }
  extrapolated = next_values
    .map { |v| v.sum }
    .zip(values.map(&:last))
    .map { |v| v.sum }
    .sum
  puts "Extrapolated: #{extrapolated}"
end

def find_next_value(values)
  differences = []
  loop do
    break if values.all? { |v| v == 0 }
    values = values.each_cons(2).map { |a, b| b - a }
    differences << values
  end
  differences
end

def part_two
  input = File.read('day9/input.txt').split("\n")
  values = input.map { |line| line.split(' ').map(&:to_i) }
  next_values = values.map { |v| find_next_value(v) }
  next_values_with_prev = next_values.map do |nv|
    reverses = nv.reverse
    answers = [0]
    reverses.each_with_index do |val, index|
      next if index + 1 == nv.length
      next_val = reverses[index + 1]
      answers << next_val.first - answers.last
    end
    answers
  end
  extrapolated = values.zip(next_values_with_prev).map do |v, nvwp|
    v.first - nvwp.last
  end.sum
  puts "Extrapolated: #{extrapolated}"
end

if __FILE__ == $0
  part_two
end