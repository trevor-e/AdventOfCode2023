NUMBER_REGEX = /[0123456789]/

def find_winners(line)
  card_content = line.split(': ')
  card_number = card_content[0].scan(NUMBER_REGEX).join.to_i
  game_content = card_content[1].split(' | ')
  winning_numbers = game_content[0].split(' ').map(&:to_i)
  game_numbers = game_content[1].split(' ').map(&:to_i)
  game_numbers.select { |num| winning_numbers.include?(num) }
end

def part_one
  input = File.read('day4/input.txt').split("\n")
  card_scores = input.map do |line|
    found_winners = find_winners(line)
    if found_winners.length == 0
      0
    else
      2 ** (found_winners.length - 1)
    end
  end
  puts card_scores.sum
end

def part_two
  input = File.read('day4/input.txt').split("\n")
  queue = []
  input.each_with_index do |line, index|
    queue << { line: line, index: index }
  end
  processed_cards = 0
  while !queue.empty?
    card = queue.shift
    processed_cards += 1
    found_winners = find_winners(card[:line])
    found_winners.each_with_index do |winner, winner_index|
      adjusted_index = card[:index] + winner_index + 1
      queue << { line: input[adjusted_index], index: adjusted_index }
    end
  end
  puts processed_cards
end

if __FILE__ == $0
  part_two
end