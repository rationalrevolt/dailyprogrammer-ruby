require 'set'

class Grid

  attr_reader :lines, :nodes, :paths

  def initialize lines
    @lines = lines
    @nodes = Hash.new

    scan_grid
  end

  def print_details
    nodes.keys.each do |n|
      puts "Node #{n.to_s} connected with: #{nodes[n].to_s}"
    end
  end

  def find_chains
    chains = []
    visited = Set.new

    nodes.keys.each do |n|
      chain = visit n unless visited.member? n
      if chain
        chain.each { |node| visited << node }
        chains << chain
      end
    end

    chains
  end

  private

  def scan_grid
    lines.each_with_index do |l, y|
      l.each_char.each_with_index do |c, x|
        nodes[[x,y]] = connected_nodes x, y if c == 'x'
      end
    end
  end

  def visit node
    chain = Set.new
    _visit node, chain
    chain.to_a
  end

  def _visit node, chain
    chain << node
    nodes[node].each { |n| _visit n, chain unless chain.member? n }
  end

  def edges x, y, dirs
    ex = []

    dirs.each do |(dx, dy)|
      tx, ty = x + dx, y + dy

      loop do
        break unless grid_marked tx,ty
        tx += dx
        ty += dy
      end

      tx -= dx
      ty -= dy

      ex << [tx,ty]
    end
    
    ex
  end

  def length
    @length ||= lines[0].length
  end

  def height
    @height ||= lines.length
  end
  
  def connected_nodes x, y
    cons = []
    
    cons << [x, y-1] if grid_marked x, y-1
    cons << [x, y+1] if grid_marked x, y+1
    cons << [x-1, y] if grid_marked x-1, y
    cons << [x+1, y] if grid_marked x+1, y

    cons
  end

  def grid_marked x, y
    lines[y][x] == 'x' unless not_within_bounds x, y
  end

  def not_within_bounds x, y
    x < 0 || x >= length || y < 0 || y >= height
  end

end

lines = File::open(ARGV.first) { |f| f.each_line.collect { |l| l.chomp }.to_a }
max_length = lines.collect { |l| l.length }.max
input = lines.collect { |l| l.ljust(max_length) }.to_a

grid = Grid.new input
puts grid.find_chains.size

__END__
xx x xx x  
x  x xx x  
xx   xx  x 
xxxxxxxxx x
         xx
xxxxxxxxxxx
 x x x x x 
  x x x x 
