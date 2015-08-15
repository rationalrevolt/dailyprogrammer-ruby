
class Spiral

  attr_reader :size

  def initialize size
    @size = size
  end

  def point_number x, y
    mx,my = mid_point

    dx = (mx - x).abs
    dy = (my - y).abs
    d = [dx,dy].max
    s = 1 + (d * 2)

    bmax = s ** 2
    bmin = (s - 2) ** 2 + 1

    bx, by = coordinates(bmax)
    if (y == by && x <= bx)
      # bottom side
      bmax - (bx - x)
    elsif (x == bx - s + 1 && y < by)
      # left side
      bmax - s - (by - 1 - y)
    elsif (y == by - s + 1 && x > bx - s + 1)
      # top side
      bmax - (2 * s - 1) - (x - (bx - s + 2))
    else
      # right side
      bmin + (y + 1 - by) 
    end
  end

  def coordinates point
    mx,my = mid_point

    b = box_number(point)

    return [mx, my] unless b
    
    bsp = b ** 2 + 1
    
    b1 = b + 1
    b2 = b + 2

    x,y = [mx + b/2 + 1, my + b/2]
    
    d = point - bsp

    if (d <= b1 - 1)
      # right side
      [x, y - d]
    else
      # top side
      d -= (b1 - 1)
      y -= (b1 - 1)
      if (d <= b2 - 1)
        [x - d, y]
      else
        # left side
        d -= (b2 - 1)
        x -= (b2 - 1)
        if (d <= b2 - 1)
          [x, y + d]
        else
          # bottom side
          d -= (b2 - 1)
          y += (b2 - 1)
          [x + d, y]
        end
      end
    end
  end

  def box_number point
    return nil if point == 1

    s = Math.sqrt(point).to_i
    if s.even?
      s - 1
    else
      s ** 2 == point ? s - 2 : s
    end
  end

  def mid_point
    [size/2 + 1, size/2 + 1]
  end

end


def assert testcase, expected, actual
  if expected == actual
    puts "Test Case #{testcase} passed."
  else
    puts "Test Case #{testcase} failed. Expected: #{expected.to_s} Actual: #{actual.to_s}"
  end
end

args = ARGV.length

case args
when 0
  assert 1, Spiral.new(3).coordinates(8), [2,3]
  assert 2, Spiral.new(7).point_number(1,1), 37
  assert 3, Spiral.new(11).coordinates(50), [10,9]
  assert 4, Spiral.new(9).point_number(6,8),47
  assert 5, Spiral.new(1024716039).coordinates(557614022), [512353188, 512346213]
  assert 6, Spiral.new(234653477).point_number(11777272, 289722), 54790653381545607
when 2
  size = ARGV[0].to_i
  point = ARGV[1].to_i
  puts "Coordinates: #{Spiral.new(size).coordinates(point).to_s}"
when 3
  size = ARGV[0].to_i
  x,y = ARGV[1..2].map {|s| s.to_i}.to_a
  puts "Point Number: #{Spiral.new(size).point_number(x,y)}"
end
