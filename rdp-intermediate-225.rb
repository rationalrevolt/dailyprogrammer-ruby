
class Grid
  
  def initialize grid
    @grid = grid
    
    @height = grid
              .map { |l| l[0] }
              .select { |c| c != '+' }
              .length
    
    @width = grid[0]
             .chars
             .select { |c| c != '+' }
             .length
    
    @newgrid = (height + width)
               .times
               .collect { Array.new(height + width) }
               .map { |arr| arr.fill(' ') }
               .to_a
    
    @cols = grid[0].length
    @rows = grid.length
    @unit = (1...cols).detect { |v| grid[0][v] == '+' }

    generate_rotated_grid
  end

  def draw
    grid_side = height + width
    grid_side.times do |i|
      puts newgrid[i].join()
    end
  end

  private
  
  attr_reader :grid, :height, :width, :unit, :rows, :cols
  attr_reader :newgrid
  
  def generate_rotated_grid
    rows.times do |r|
      x = height - r + r/unit
      y = r - r/unit

      cols.times do |c|
        case grid[r][c]
        when '-'
          newgrid[y][x] = '\\'
          x += 1
          y += 1
        when '|'
          newgrid[y-1][x] = '/'
        when ' '
          if (r % unit == 0) || (c % unit != 0)
            x += 1
            y += 1
          end
        end
      end
    end
  end

end

inputs = DATA.each_line.reduce([]) do |xs, l|
  if l.chomp.length == 0
    xs << []
  else
    xs.last << l.chomp
    xs
  end    
end

inputs.each do |lines|
  puts
  Grid.new(lines).draw
end

__END__

+---+---+---+---+---+---+
                        |
                        |
                        |
+---+---+---+---+---+   +
                        |
                        |
                        |
+---+---+---+---+---+---+
|                        
|                        
|                        
+   +---+---+---+---+---+
|                        
|                        
|                        
+---+---+---+---+---+---+

+-+-+-+-+-+
  |       |
+ +-+-+ + +
| |     | |
+ + + + + +
|   | |   |
+-+-+ +-+-+
|     |   |
+ + +-+ + +
| |     |  
+-+-+-+-+-+

+--+--+--+--+--+
      |     |  |
      |     |  |
+  +--+  +  +  +
|     |  |  |  |
|     |  |  |  |
+--+  +  +  +  +
|     |  |     |
|     |  |     |
+  +--+  +  +--+
|        |     |
|        |     |
+--+--+--+--+  +
|               
|               
+--+--+--+--+--+
