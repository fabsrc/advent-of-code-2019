class Amplifier
  def initialize(ops, phase)
    @pos = 0
    @ops = ops.dup
    run(phase)
  end

  def run(*inputs)
    loop do
      op_digits = @ops[@pos].to_s.chars
      op_code = op_digits.last(2).join.to_i
      modes = op_digits[0...-2].reverse.map(&:to_i)
      param_1 = modes[0] == 1 ? @pos + 1 : @ops[@pos + 1]
      param_2 = modes[1] == 1 ? @pos + 2 : @ops[@pos + 2]
      
      case op_code
      when 99
        break
      when 1
        @ops[@ops[@pos + 3]] = @ops[param_1] + @ops[param_2]
        @pos += 4
      when 2
        @ops[@ops[@pos + 3]] = @ops[param_1] * @ops[param_2]
        @pos += 4
      when 3
        input = inputs.shift
        break unless input
        @ops[@ops[@pos + 1]] = input
        @pos += 2
      when 4
        @pos += 2
        return @ops[param_1]
      when 5
        @pos = @ops[param_1] != 0 ? @ops[param_2] : @pos + 3
      when 6
        @pos = @ops[param_1] == 0 ? @ops[param_2] : @pos + 3
      when 7
        @ops[@ops[@pos + 3]] = @ops[param_1] < @ops[param_2] ? 1 : 0
        @pos += 4
      when 8
        @ops[@ops[@pos + 3]] = @ops[param_1] == @ops[param_2] ? 1 : 0
        @pos += 4
      end
    end
  end
end

def get_max_thruster_signal(ops, phases)
  signals = phases.to_a.permutation.map do |seq|
    amplifiers = seq.map{ |phase| Amplifier.new(ops, phase) }
    signal = 0

    amplifiers.cycle do |amp|
      out = amp.run(signal)
      break unless out
      signal = out if out
    end

    signal
  end
  
  signals.max
end

# Part 1
raise unless get_max_thruster_signal([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0], 0..4) == 43210
raise unless get_max_thruster_signal([3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0], 0..4) == 54321
raise unless get_max_thruster_signal([3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0], 0..4) == 65210

# Part 2
raise unless get_max_thruster_signal([3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5], 5..9) == 139629729
raise unless get_max_thruster_signal([3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10], 5..9) == 18216

unless ARGV.empty?
  ops = ARGV[0].split(',').map(&:to_i)
  puts get_max_thruster_signal(ops, 0..4)
  puts get_max_thruster_signal(ops, 5..9)
end
