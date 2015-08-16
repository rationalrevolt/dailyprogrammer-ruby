class AsciiRect

  attr_reader :matrix, :graph

  def initialize source
    @matrix = read source
    @graph = Graph.new

    scan_points
  end

  def pretty_print
    matrix.map { |row| puts row }
  end

  def find_all_rectangles &blk
    graph.find_all_rectangles &blk
  end

  def read source
    lines = source.readlines.collect { |l| l.chomp }
    max_line_length = lines.map { |l| l.length }.max

    matrix = []
    lines.each do |l|
      row = String.new
      row << l.gsub(/[^\+\-\|]/, '.')
      row << '.' * (max_line_length - row.length)
      matrix << row
    end

    matrix
  end

  def rows
    matrix.length
  end

  def cols
    matrix[0].length
  end

  def scan_points
    scan_points_horizontal
    scan_points_vertical
  end

  def scan_points_horizontal
    matrix.each_with_index do |r, row_num|
      points = []
      in_line = false
      r.chars.each_with_index do |c, col_num|
        case c
        when '+'
          points << "#{row_num}:#{col_num}"
          in_line = true
        when '-'
          in_line = true
        when '.'
          in_line = false
          connect_horizontal points
          points = []
        end
      end
      connect_horizontal points if in_line and points.length > 1
    end
  end

  def scan_points_vertical
    0.upto(cols - 1) do |col_num|
      points = []
      in_line = false
      0.upto(rows - 1) do |row_num|
        case matrix[row_num][col_num]
        when '+'
          points << "#{row_num}:#{col_num}"
          in_line = true
        when '|'
          in_line = true
        when '.'
          in_line = false
          connect_vertical points
          points = []
        end
      end
      connect_vertical points if in_line and points.length > 1
    end
  end
          
  def connect_horizontal points
    graph.connect_points points, :right
    graph.connect_points points.reverse, :left
  end

  def connect_vertical points
    graph.connect_points points, :down
    graph.connect_points points.reverse, :up
  end
  
end

class Graph

  attr_reader :nodes, :notify_proc

  def initialize
    @nodes = Hash.new
  end

  def directions
    [:right, :down, :left, :up]
  end

  def ensure_node p
    nodes[p] ||= Hash.new
  end

  def connect_points points, direction
    points.each { |p| ensure_node p }

    0.upto(points.length - 2) do |p_num|
      node_p = nodes[points[p_num]]
      q = points[p_num + 1]
      node_p[direction] = q
    end
  end

  def find_all_rectangles &blk
    @notify_proc = blk
    nodes.keys.each { |p| start_finding_from p }
  end

  def start_finding_from p
    traverse [p], directions.first, directions.drop(1)
  end

  def traverse path, towards, remaining
    start = path.first
    just_one_left = remaining.length == 1
    next_towards = remaining.first
    from = path.last
    n = nodes[from]
    next_move_same_dir = n[towards]

    if just_one_left and possible_from_to(from, next_towards, start)
      found_path(path) and return
    end

    if next_move_same_dir
      new_path = path.clone
      if path.length == 1
        new_path << next_move_same_dir
      else
        new_path[-1] = next_move_same_dir
      end
      traverse new_path, towards, remaining
    end

    unless just_one_left
      next_towards = remaining.first
      next_remaining = remaining.drop(1)
      next_move = n[next_towards]
      if next_move
        new_path = path.clone
        new_path << next_move
        traverse new_path, next_towards, next_remaining
      end
    end
  end

  def possible_from_to from, direction, to
    while nodes[from][direction]
      from = nodes[from][direction]
      return true if from == to
    end

    return false
  end

  def found_path path
    notify_proc.call "Found Rectangle: #{path.to_s}"
  end

  def pretty_print
    nodes.each do |p, p_node|
      directions.each do |dir|
        puts "#{p} #{dir} #{p_node[dir]}" if p_node[dir]
      end
    end
  end

end
      
rect = AsciiRect.new($stdin)

puts
rect.pretty_print
puts

total_rects = 0
rect.find_all_rectangles do |msg|
  puts msg
  total_rects += 1
end

puts
puts "Total Rectangles Found: #{total_rects}"
