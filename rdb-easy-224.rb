def inplace_shuffle arr
  r = Random.new
  size = arr.length
  size.downto(1) do |n|
    i = r.rand(n)
    arr[i], arr[n-1] = arr[n-1], arr[i]
  end
end

def shuffle arr
  r = Random.new
  new_arr = []
  0.upto(arr.length - 1) do |n|
    i = r.rand(n + 1)
    if i == n
      new_arr << arr[n]
    else
      new_arr << new_arr[i]
      new_arr[i] = arr[n]
    end
  end

  new_arr
end

arr = (1..ARGV[0].to_i).to_a

puts "Input: #{arr.to_s}"
puts "Copy shuffle: #{shuffle(arr).to_s}"

inplace_shuffle arr

puts "Inplace shuffle: #{arr.to_s}"
