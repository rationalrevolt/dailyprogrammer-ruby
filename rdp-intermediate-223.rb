require 'set'

def seq_gen length
  Enumerator.new do |y|
    start = seq = 'a' * length
    loop do
      y.yield seq
      seq = seq.next
      break if seq.length > length
    end
  end
end

def check word, banned
  banned_hash = banned.chars.to_set
  exposed_chars = word.chars.select { |c| banned_hash.include? c }
  banned.chars.eql? exposed_chars
end

banned = ARGV.first

def check_dict banned
  problem_word_cnt = 0

  File.open("dict.txt") do |f|
    until f.eof?
      input_word = f.readline.chomp
      if !input_word.empty? && check(input_word, banned)
        problem_word_cnt += 1
      end
    end

    [banned, problem_word_cnt]
  end
end

puts check_dict(banned).to_s
