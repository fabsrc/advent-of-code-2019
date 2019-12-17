def get_fft(input_signal, phases)
  pattern = [0, 1, 0, -1]

  phases.times do
    input_signal.map_with_index! { |_, i|
      input_signal.skip(i).map_with_index { |d, j|
        d * pattern[((i + j + 1) / (i + 1)).to_i % 4]
      }.sum.abs % 10
    }
  end

  input_signal.first(8).join
end

def get_fft2(input_signal)
  input_signal = input_signal * 10000
  offset = input_signal.first(7).join.to_i

  100.times do
    sum = input_signal.skip(offset).sum
    (offset...input_signal.size).each do |idx|
      number = sum
      sum -= input_signal[idx]
      input_signal[idx] = number.abs % 10
    end
  end

  inputs.skip(offset).first(8).join
end

puts get_fft("12345678".chars.map(&.to_i), 4) == "01029498"
puts get_fft("80871224585914546619083218645595".chars.map(&.to_i), 100) == "24176176"
puts get_fft("19617804207202209144916044189917".chars.map(&.to_i), 100) == "73745418"
puts get_fft("69317163492948606335995924319873".chars.map(&.to_i), 100) == "52432133"

puts get_fft2("03036732577212944063491565474664".chars.map(&.to_i), 100) == "84462026"
puts get_fft2("02935109699940807407585447034323".chars.map(&.to_i), 100) == "78725270"
puts get_fft2("03081770884921959731165446850517".chars.map(&.to_i), 100) == "53553731"

if ARGV.size > 0
  input = ARGV[0].chars.map(&.to_i)
  puts get_fft(input, 100)
  puts get_fft2(input, 100)
end
