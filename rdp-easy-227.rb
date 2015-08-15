
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
    
    min = 1
    max = size
    loop do
      mid = (min + max) / 2
      mid -= 1 if mid.even?
      lp = mid ** 2
      rp = (mid + 2) ** 2

      return mid if lp < point && point <= rp

      if point > lp
        min = mid
      else
        max = mid
      end
    end
  end

  def mid_point
    [size/2 + 1, size/2 + 1]
  end

end

args = ARGV.length

case args
when 2
  size = ARGV[0].to_i
  point = ARGV[1].to_i
  puts "Coordinates: #{Spiral.new(size).coordinates(point).to_s}"
when 3
  size = ARGV[0].to_i
  x,y = ARGV[1..2].map {|s| s.to_i}.to_a
  puts "Point Number: #{Spiral.new(size).point_number(x,y)}"
end
