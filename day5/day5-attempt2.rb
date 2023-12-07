require_relative '../utils'

SeedRange = Data.define(:start, :length)
AlmanacMap = Data.define(:source, :length, :dest)

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

  seed_ranges.sort_by! { |s| s.start }
  puts "Found result #{seed_ranges.first.start}"
end

def convert_seeds(seed_ranges, mapping)
  new_seed_ranges = []

  for seed_range in seed_ranges do
    target_range = (seed_range.start)...(seed_range.start + seed_range.length)
    found_mapping = mapping.find { |m| m[0].intersect?(target_range) }

    # no mapping found so include identity
    if found_mapping.nil?
      puts "No mapping found, adding identity for #{target_range}"
      new_seed_ranges << seed_range
      next
    end

    overlap_start = [found_mapping[0].begin, target_range.begin].max
    overlap_end = [found_mapping[0].max, target_range.max].min

    # Add the overlapping range to the MAPPED value
    mapped_range = SeedRange.new(start: found_mapping[1] + overlap_start, length: overlap_end - overlap_start + 1)
    puts "Adding mapped range #{found_mapping[1] + overlap_start...(found_mapping[1] + overlap_start + overlap_end - overlap_start)}"
    new_seed_ranges << mapped_range

    # Recursively add the non-overlapping ranges to see if they match other mappings
    # Essentially this is the spillover

    if overlap_start > target_range.begin
      start_range = SeedRange.new(start: target_range.begin, length: overlap_start - target_range.begin)
      puts "Recursively finding start range #{target_range.begin...(target_range.begin + overlap_start - target_range.begin)}"
      new_seed_ranges.concat(convert_seeds([start_range], mapping))
    end

    if target_range.max > overlap_end
      end_range = SeedRange.new(start: overlap_end + 1, length: target_range.max - overlap_end)
      puts "Recursively finding end range #{(overlap_end + 1)...(overlap_end + 1 + target_range.max - overlap_end)}"
      new_seed_ranges.concat(convert_seeds([end_range], mapping))
    end
  end

  new_seed_ranges.sort_by { |s| s.start }
end

def parse_range_map(lines, section_name)
  parse_section_map(lines, section_name).to_h { |m| [(m.source)...(m.source + m.length), m.dest] }
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
  part_two
end