NODE_MAP_REGEX = /([A-Z0-9]+) = \(([A-Z0-9]+), ([A-Z0-9]+)\)/
NodeMap = Data.define(:node, :left, :right)

def part_one
  input = File.read('day8/input.txt').split("\n")
  directions = input[0]
  node_maps = input.drop(2).map do |line|
    values = line.match(NODE_MAP_REGEX).captures
    NodeMap.new(node: values[0], left: values[1], right: values[2])
  end
  node_map_hash = node_maps.to_h { |node_map| [node_map.node, node_map] }

  index = 0
  current_node = node_maps.find { |node_map| node_map.node == 'AAA' }
  num_moves = 0
  loop do
    break if current_node.node == 'ZZZ'

    char = directions[index]
    num_moves += 1
    if char == 'L'
      puts "Traveling left from #{current_node.node} -> #{current_node.left}"
      current_node = node_map_hash[current_node.left]
    else
      puts "Traveling right from #{current_node.node} -> #{current_node.right}"
      current_node = node_map_hash[current_node.right]
    end

    index += 1
    index = 0 if index == directions.length
  end
  puts "Found ZZZ in #{num_moves} moves"
end

def moves_until_next_z(directions, direction_index, current_node, node_map_hash)
  num_moves = 0
  loop do
    break if current_node.node.end_with?('Z')
    needs_skip = false

    char = directions[direction_index]
    num_moves += 1

    if char == 'L'
      current_node = node_map_hash[current_node.left]
    else
      current_node = node_map_hash[current_node.right]
    end

    direction_index += 1
    direction_index = 0 if direction_index == directions.length
  end
  num_moves
end

def part_two
  input = File.read('day8/input.txt').split("\n")
  directions = input[0]
  node_maps = input.drop(2).map do |line|
    values = line.match(NODE_MAP_REGEX).captures
    NodeMap.new(node: values[0], left: values[1], right: values[2])
  end
  node_map_hash = node_maps.to_h { |node_map| [node_map.node, node_map] }
  current_nodes = node_maps.select { |node_map| node_map.node.end_with?('A') }
  moves_needed = current_nodes.map { |node| moves_until_next_z(directions, 0, node, node_map_hash) }
  min_moves_needed = moves_needed.reduce(:lcm)
  puts "Found ZZZ for all in #{min_moves_needed} moves"
end

if __FILE__ == $0
  part_two
end