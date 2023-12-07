require_relative '../utils'

SeedRange = Data.define(:start, :length)
AlmanacMap = Data.define(:source, :length, :dest)

def parse_section_map(lines, section_name)
  results = []
  found_section = false
  line_regex = /(\d+) (\d+) (\d+)/
  lines.each do |line|
    if line == section_name
      found_section = true
    elsif found_section
      if line =~ line_regex
        results << line.scan(line_regex).flatten.map(&:to_i)
      else
        break
      end
    end
  end
  results
    .map { |r| AlmanacMap.new(source: r[1], length: r[2], dest: r[0]) }
    .sort { |a, b| a.source <=> b.source }
end

def find_range_mapping(mapping, target)
  mapping.each do |map|
    if target >= map[1] && target < map[1] + map[2]
      extra = target - map[1]
      return map[0] + extra
    end
  end
  target
end

def part_one
  input = File.read('day5/input.txt').split("\n")
  seeds = input[0].split('seeds: ')[1].split(' ').map(&:to_i)

  # dest_range_start source_range_start range_length
  # missing mapping will map to itself
  seed_to_soil = parse_section_map(input, 'seed-to-soil map:')
  soil_to_fertilizer = parse_section_map(input, 'soil-to-fertilizer map:')
  fertilier_to_water = parse_section_map(input, 'fertilizer-to-water map:')
  water_to_light = parse_section_map(input, 'water-to-light map:')
  light_to_temperature = parse_section_map(input, 'light-to-temperature map:')
  temperature_to_humidity = parse_section_map(input, 'temperature-to-humidity map:')
  humidity_to_location = parse_section_map(input, 'humidity-to-location map:')

  seed_locations = seeds.map do |seed|
    mapped = find_range_mapping(seed_to_soil, seed)
    mapped = find_range_mapping(soil_to_fertilizer, mapped)
    mapped = find_range_mapping(fertilier_to_water, mapped)
    mapped = find_range_mapping(water_to_light, mapped)
    mapped = find_range_mapping(light_to_temperature, mapped)
    mapped = find_range_mapping(temperature_to_humidity, mapped)
    mapped = find_range_mapping(humidity_to_location, mapped)
    mapped
  end
  puts seed_locations.min
end

def parse_range_map(lines, section_name)
  parse_section_map(lines, section_name).to_h { |m| [(m.source)...(m.source + m.length), m.dest] }
end

# Current guesses:
# 0
# 166086528
# 280549587
# 953918455
# correct answer -> 84206669
def convert_seeds(seed_ranges, mapping)
  new_seed_ranges = []
  for seed_range in seed_ranges do
    target_range = (seed_range.start)...(seed_range.start + seed_range.length)
    range = mapping.keys.find { |r| r.intersect?(target_range) }

    # mapping not found so include identity range
    if !range
      puts "No mapping found for #{target_range}"
      new_seed_ranges << seed_range
      next
    end

    # Entire range is covered by mapping so convert fully
    if range.cover?(target_range)
      puts "Full mapping found for #{target_range}"
      new_seed_ranges << SeedRange.new(start: mapping[range], length: seed_range.length)
      next
    end

    # Partial range is covered, so need to split into potentially 3 ranges with mappings
    # First range is the mapped range
    # Other ranges are identity ranges for the parts not covered by the mapping
    max_start = [range.begin, target_range.begin].max
    min_end = [range.end, target_range.end].min
    puts "Adding partial mapping for #{mapping[range] + max_start}...#{mapping[range] + max_start + min_end - max_start}"
    new_seed_ranges << SeedRange.new(start: mapping[range] + max_start, length: min_end - max_start)

    if max_start > target_range.begin
      puts "Adding identity range for start #{target_range.begin}...#{target_range.begin + max_start - target_range.begin}"
      new_seed_ranges.concat(convert_seeds([SeedRange.new(start: target_range.begin, length: max_start - target_range.begin)], mapping))
    end

    if target_range.end > min_end
      puts "Adding identity range for end #{min_end}...#{min_end + target_range.end - min_end}"
      new_seed_ranges.concat(convert_seeds([SeedRange.new(start: min_end, length: target_range.end - min_end)], mapping))
    end
  end
  new_seed_ranges.sort_by { |s| s.start }
end

def part_two
  input = File.read('day5/input.txt').split("\n")
  seed_ranges = input[0]
    .split('seeds: ')[1]
    .split(' ')
    .map(&:to_i)
    .each_slice(2)
    .map { |s| SeedRange.new(start: s[0], length: s[1]) }
    .sort_by { |s| s.start }

  seed_to_soil = parse_range_map(input, 'seed-to-soil map:')
  soil_to_fertilizer = parse_range_map(input, 'soil-to-fertilizer map:')
  fertilier_to_water = parse_range_map(input, 'fertilizer-to-water map:')
  water_to_light = parse_range_map(input, 'water-to-light map:')
  light_to_temperature = parse_range_map(input, 'light-to-temperature map:')
  temperature_to_humidity = parse_range_map(input, 'temperature-to-humidity map:')
  humidity_to_location = parse_range_map(input, 'humidity-to-location map:')

  maps = [seed_to_soil, soil_to_fertilizer, fertilier_to_water, water_to_light, light_to_temperature, temperature_to_humidity, humidity_to_location]
  for map in maps do
    seed_ranges = convert_seeds(seed_ranges, map)
  end

  puts seed_ranges.min_by { |s| s.start }.start
end

if __FILE__ == $0
  part_two
end