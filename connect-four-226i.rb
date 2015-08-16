class Board

  attr_reader :board

  def initialize
    @board = 6.times.collect { Array.new(7) }
  end

  def play sym, c
    r = empty_row_for c
    if r
      board[r][c] = sym
      check_win r,c
    end
  end

  def empty_row_for c
    0.upto(5).detect { |r| board[r][c].nil? }
  end

  def check_win row, col
    directions = [:horizontal, :vertical, :diagonal_1, :diagonal_2]
    board[row][col] if directions.map { |d| extent_along row, col, d }.include?(4)
  end

  def extent_along row, col, direction
    ri, ci = increments_along direction
    
    e_1 = extent_for row, col, ri, ci
    e_2 = extent_for row, col, -ri, -ci

    e_1 + e_2 + 1
  end

  def increments_along direction
    case direction
    when :horizontal then [0, 1]
    when :vertical   then [1, 0]
    when :diagonal_1 then [1, 1]
    when :diagonal_2 then [1,-1]
    end
  end

  def extent_for row, col, ri, ci
    result = 0

    sym = board[row][col]
    r, c = row + ri, col + ci
    
    while within_bounds?(r, c)
      break unless board[r][c] == sym
      r += ri
      c += ci
      result += 1
    end

    result
  end

  def within_bounds? r, c
    (0..5).include?(r) && (0..6).include?(c)
  end  

  def draw
    puts
    puts " |a b c d e f g "
    puts "----------------"
    6.times do |r|
      rs = "#{6 - r}|"
      7.times do |c|
        cell = board[5 - r][c] || '.'
        rs += cell + ' '
      end
      puts rs
    end
  end
  
end

def player_symbol c
  c == c.upcase ? 'X' : 'O'
end

def column_index c
  ('a'..'g').find_index(c.downcase)
end

board = Board.new
moves = DATA
        .each_line
        .map { |l| l.chomp }
        .join(' ')
        .split(' ')
        .map { |c| [player_symbol(c), column_index(c)] }

result = nil
moves.each do |move|
  player, column = move
  result = board.play player, column
  board.draw
  break if result
end

puts
puts "#{result} wins!"

__END__
D  d
D  c    
C  c    
C  c
G  f
F  d
F  f
D  f
A  a
E  b
E  e
B  g
G  g
B  a
