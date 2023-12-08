require_relative '../utils'

AlmanacMap = Data.define(:source, :length, :dest)

def find_range_mapping(mapping, target)
  mapping.each do |map|
    if target >= map.source && target < map.source + map.length
      extra = target - map.source
      return map.dest + extra
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

def part_two
  input = File.read('day5/input.txt').split("\n")
  seed_ranges = input[0]
    .split('seeds: ')[1]
    .split(' ')
    .map(&:to_i)
    .each_slice(2)
    .map { |s| s[0]..(s[0] + s[1]) }
    .sort_by { |s| s.begin }

  seed_to_soil = parse_range_map(input, 'seed-to-soil map:')
  soil_to_fertilizer = parse_range_map(input, 'soil-to-fertilizer map:')
  fertilier_to_water = parse_range_map(input, 'fertilizer-to-water map:')
  water_to_light = parse_range_map(input, 'water-to-light map:')
  light_to_temperature = parse_range_map(input, 'light-to-temperature map:')
  temperature_to_humidity = parse_range_map(input, 'temperature-to-humidity map:')
  humidity_to_location = parse_range_map(input, 'humidity-to-location map:')

  maps = [seed_to_soil, soil_to_fertilizer, fertilier_to_water, water_to_light, light_to_temperature, temperature_to_humidity, humidity_to_location]
  for map in maps do
    new_seeds = []
    for seed_range in seed_ranges do
      converted_seeds = convert_seed(map, seed_range)
      new_seeds.concat(converted_seeds)
    end
    seed_ranges = new_seeds
  end

  seed_ranges.sort_by! { |s| s.begin }
  puts "Found result #{seed_ranges.first.begin}"
end

def convert_seed(map, seed_range)
  new_seeds = []
  for mapping in map do
    mapping_range = mapping[0]
    mapping_offset = mapping[1] - mapping_range.begin

    # Skip since the seed range is outside of the mapping range
    if seed_range.end < mapping_range.begin || seed_range.begin > mapping_range.end
      next
    end

    # If the seed range is completely contained within the mapping range, then we can just add the offset
    if mapping_range.cover?(seed_range)
      puts "Mapping range covers seed range #{seed_range}"
      new_seeds << Range.new(seed_range.begin + mapping_offset, seed_range.end + mapping_offset)
      break
    end

    # If the seed range is partially contained within the mapping range, then we need to split it up
    # into three separate ranges
    if seed_range.cover?(mapping_range)
      puts "Mapping range is contained within seed range #{seed_range}"
      new_seeds.concat(convert_seed(map, Range.new(seed_range.begin, mapping_range.begin - 1)))
      new_seeds << Range.new(mapping_range.begin + mapping_offset, mapping_range.end + mapping_offset)
      new_seeds.concat(convert_seed(map, Range.new(mapping_range.end + 1, seed_range.end)))
      break
    end

    # If the seed range is partially before the mapping range, then we need to split it up
    if seed_range.begin <= mapping_range.begin && seed_range.end <= mapping_range.end
      puts "Mapping range is partially before seed range #{seed_range}"
      new_seeds << Range.new(mapping_range.begin + mapping_offset, seed_range.end + mapping_offset)
      if seed_range.begin < mapping_range.begin
        new_seeds.concat(convert_seed(map, Range.new(seed_range.begin, mapping_range.begin - 1)))
      end
      break
    end

    # If the seed range is partially after the mapping range, then we need to split it up
    if seed_range.begin >= mapping_range.begin && seed_range.end >= mapping_range.end
      puts "Mapping range is partially after seed range #{seed_range}"
      new_seeds << Range.new(seed_range.begin + mapping_offset, mapping_range.end + mapping_offset)
      if seed_range.end > mapping_range.end
        new_seeds.concat(convert_seed(map, Range.new(mapping_range.end + 1, seed_range.end)))
      end
      break
    end
  end
  new_seeds
end

def parse_range_map(lines, section_name)
  parse_section_map(lines, section_name).to_h { |m| [Range.new(m.source, m.source + m.length - 1), m.dest] }
end

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
    .sort_by { |m| m.source }
end

if __FILE__ == $0
  part_one
end