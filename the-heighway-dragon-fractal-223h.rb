# coding: utf-8
class Heighway

  attr_reader :order, :order_1_angle
  
  def initialize order
    @order = order
    @order_1_angle = :left
  end

  def steps
    _steps order
  end

  def _steps order
    if order == 1
      [:forward, order_1_angle, :forward]
    else
      steps_previous = _steps(order - 1)
      left_half = steps_previous
      right_half = mirror(left_half)
      left_half + [order_1_angle] + right_half
    end
  end

  def mirror path
    len = path.length
    mid = len / 2

    path.clone.tap do |m_path|
      mid_dir = path[mid]
      m_path[mid] = opposite(mid_dir)
    end
  end

  def opposite direction
    case direction
    when :left  then :right
    when :right then :left
    end
  end

  def draw
    path = steps

    min_x = max_x = min_y = max_y = 0
    x,y = 0,0
    facing = :right
    
    left_turn = {up: :left, left: :down, down: :right, right: :up}
    right_turn = {up: :right, right: :down, down: :left, left: :up}

    points = [[0,0,'.']]

    move_forward = Proc.new do
      case facing
      when :up;    points << [x,y + 1,'|']; points << [x,y + 2,'.']; y += 2
      when :down;  points << [x,y - 1,'|']; points << [x,y - 2,'.']; y -= 2
      when :right; points << [x + 1,y,'-']; points << [x + 2,y,'.']; x += 2
      when :left;  points << [x - 1,y,'-']; points << [x - 2,y,'.']; x -= 2
      end
    end
    
    path.each do |step|
      case step
      when :forward; move_forward.call
      when :left;    facing = left_turn[facing]
      when :right;   facing = right_turn[facing]
      end

      min_x = x if x < min_x
      max_x = x if x > max_x
      min_y = y if y < min_y
      max_y = y if y > max_y
    end

    width = (max_x - min_x).magnitude + 1
    height = (max_y - min_y).magnitude + 1
    x_offset = -min_x
    y_offset = -min_y

    translated_points = points.collect do |p|
      x,y,sym = p
      [x + x_offset, y + y_offset, sym]
    end

    lines = height.times.collect { ' ' * width }.to_a
    translated_points.each do |p|
      x, y, sym = p
      lines[y][x] = sym
    end

    lines.each { |l| puts l }
  end

end

order = ARGV.first || 10

Heighway.new(order.to_i).draw
