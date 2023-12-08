CardHands = Data.define(:cards, :bid)

def char_strength(char)
  case char
  when 'A'
    14
  when 'K'
    13
  when 'Q'
    12
  when 'T'
    10
  when 'J'
    1
  else
    char.to_i
  end
end

def get_frequency(hand)
  frequency = Hash.new(0)
  hand.each_char do |char|
    frequency[char] += 1
  end
  frequency
end

def find_best_joker_sub(hand)
  if hand == 'JJJJJ'
    return 'A'
  end
  hand_without_joker = hand.gsub('J', '')
  frequency = get_frequency(hand_without_joker)
  max_kind = frequency.values.max
  remaining_keys = frequency
    .select { |k, v| v == max_kind }
    .map { |k, v| k }
    .sort_by { |k| char_strength(k) }
  remaining_keys[0]
end

def calc_hand_score(hand)
  if hand.include?('J')
    sub = find_best_joker_sub(hand)
    hand = hand.gsub('J', sub)
  end

  frequency = get_frequency(hand)
  max_kind = frequency.values.max

  # 5 of a kind
  if max_kind == 5
    return 7
  # 4 of a kind
  elsif max_kind == 4
    return 6
  # Full house
  elsif max_kind == 3 && frequency.values.length == 2
    return 5
  # 3 of a kind
  elsif max_kind == 3
    return 4
  # 2 pair
  elsif max_kind == 2 && frequency.values.length == 3
    return 3
  # 1 pair
  elsif frequency.values.length == 4
    return 2
  else
    return 1
  end
end

def compare_hands(hand1, hand2)
  hand_1_score = calc_hand_score(hand1)
  hand_2_score = calc_hand_score(hand2)

  if hand_1_score > hand_2_score
    return 1
  elsif hand_1_score < hand_2_score
    return -1
  end

  hand1.chars.zip(hand2.chars).each do |char1, char2|
    if char_strength(char1) > char_strength(char2)
      return 1
    elsif char_strength(char1) < char_strength(char2)
      return -1
    end
  end

  0
end

def part_one
  input = File.read('day7/input.txt').split("\n")
  card_hands = input.map { |line| CardHands.new(cards: line.split(' ')[0], bid: line.split(' ')[1].to_i) }
  card_hands.sort! do |a, b|
    compare_hands(a.cards, b.cards)
  end
  total_winnings = card_hands.each_with_index.map do |card_hand, index|
    (index + 1) * card_hand.bid
  end.reduce(:+)
  puts "total_winnings: #{total_winnings}"
end

def part_two
  input = File.read('day7/input.txt').split("\n")
  card_hands = input.map { |line| CardHands.new(cards: line.split(' ')[0], bid: line.split(' ')[1].to_i) }
  card_hands.sort! do |a, b|
    compare_hands(a.cards, b.cards)
  end
  total_winnings = card_hands.each_with_index.map do |card_hand, index|
    (index + 1) * card_hand.bid
  end.reduce(:+)
  puts "total_winnings: #{total_winnings}"
end

if __FILE__ == $0
  part_two
end