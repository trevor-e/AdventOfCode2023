def part_one
  input = File.read('day2/input.txt').split("\n")
  digits_regex = /[1234567890]/
  red_regex = /(\d+) red/
  green_regex = /(\d+) green/
  blue_regex = /(\d+) blue/
  # only 12 red cubes, 13 green cubes, and 14 blue cubes
  game_results = input.map do |line|
    game_id = line.split(': ')[0].scan(digits_regex).join.to_i
    game_result = line.split(': ')[1]
    reds = game_result.scan(red_regex).flatten.map(&:to_i).max
    greens = game_result.scan(green_regex).flatten.map(&:to_i).max
    blues = game_result.scan(blue_regex).flatten.map(&:to_i).max
    { game_id: game_id, reds: reds, greens: greens, blues: blues }
  end.select do |game_result|
    game_result[:reds] <= 12 && game_result[:greens] <= 13 && game_result[:blues] <= 14
  end
  puts game_results.map{|g| g[:game_id]}.sum
end

def part_two
  input = File.read('day2/input.txt').split("\n")
  digits_regex = /[1234567890]/
  red_regex = /(\d+) red/
  green_regex = /(\d+) green/
  blue_regex = /(\d+) blue/
  game_powers = input.map do |line|
    game_id = line.split(': ')[0].scan(digits_regex).join.to_i
    game_result = line.split(': ')[1]
    reds = game_result.scan(red_regex).flatten.map(&:to_i).max
    greens = game_result.scan(green_regex).flatten.map(&:to_i).max
    blues = game_result.scan(blue_regex).flatten.map(&:to_i).max
    reds * greens * blues
  end
  puts game_powers.sum
end

if __FILE__ == $0
  part_two
end