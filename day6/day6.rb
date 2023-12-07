TimeAndDistance = Data.define(:time, :record_distance)

def find_winner_counts(time_and_distance)
  winning_distances = []

  time_remaining = time_and_distance.time - 1
  speed = 1
  while time_remaining > 0 do
    distance = time_remaining * speed
    if distance > time_and_distance.record_distance
      winning_distances << distance
    end
    speed += 1
    time_remaining -= 1
  end

  winning_distances.length
end

def part_one
  # Your toy boat has a starting speed of zero millimeters per millisecond.
  # For each whole millisecond you spend at the beginning of the race holding down the button, the boat's speed increases by one millimeter per millisecond.

  # To see how much margin of error you have, determine the number of ways you can beat the record in each race;
  # in this example, if you multiply these values together, you get 288 (4 * 8 * 9).
  input = File.read('day6/input.txt').split("\n")
  times = input[0].scan(/\d+/).map(&:to_i)
  distances = input[1].scan(/\d+/).map(&:to_i)
  time_and_distances = times.map.with_index do |time, index|
    TimeAndDistance.new(time: time, record_distance: distances[index])
  end
  winners = time_and_distances.map do |time_and_distance|
    find_winner_counts(time_and_distance)
  end.flatten.reduce(&:*)
  puts winners
end

def part_two
  input = File.read('day6/input.txt').split("\n")
  time = input[0].gsub(/[^\d]/, '').to_i
  distance = input[1].gsub(/[^\d]/, '').to_i
  time_and_distance = TimeAndDistance.new(time: time, record_distance: distance)
  winners = find_winner_counts(time_and_distance)
  puts winners
end

if __FILE__ == $0
  part_two
end