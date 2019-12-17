class Program
  def initialize(ops)
    @pos = 0
    @ops = ops.dup
    @relative_base = 0
    @halted = false
  end

  def halted?
    @halted
  end

  def run_ops(inputs = [])
    def get_op(pos)
      @ops[pos] || 0
    end

    def get_param(no, modes)
      case modes[no - 1]
      when 1
        @pos + no
      when 2
        @relative_base + get_op(@pos + no)
      else
        get_op(@pos + no)
      end
    end

    loop do
      op = get_op(@pos)
      op_code = op % 100
      modes = op.digits.drop(2)
      param_1 = get_param(1, modes)
      param_2 = get_param(2, modes)
      param_3 = get_param(3, modes)

      case op_code
      when 99
        @halted = true
        return
      when 1
        @ops[param_3] = get_op(param_1) + get_op(param_2)
        @pos += 4
      when 2
        @ops[param_3] = get_op(param_1) * get_op(param_2)
        @pos += 4
      when 3
        input = inputs.shift
        break unless input
        @ops[param_1] = input
        @pos += 2
      when 4
        @out = get_op(param_1)
        @pos += 2
        return @out
      when 5
        @pos = get_op(param_1) != 0 ? get_op(param_2) : @pos + 3
      when 6
        @pos = get_op(param_1) == 0 ? get_op(param_2) : @pos + 3
      when 7
        @ops[param_3] = get_op(param_1) < get_op(param_2) ? 1 : 0
        @pos += 4
      when 8
        @ops[param_3] = get_op(param_1) == get_op(param_2) ? 1 : 0
        @pos += 4
      when 9
        @relative_base += get_op(param_1)
        @pos += 2
      end
    end
  end
end

def sum_of_alignment_parameters(ops)
  program = Program.new(ops)

  scaffold_positions = []
  line = 0
  col = 0

  until program.halted?
    out = program.run_ops()
    scaffold_positions << [line, col] if out == 35
    if out == 10
      line += 1
      col = 0
    else
      col += 1
    end
  end

  scaffold_positions.sum{ |line, col|
    positions = [
      [line + 1, col],
      [line - 1, col],
      [line, col + 1],
      [line, col - 1]
    ]
    is_intersection = positions.all? { |pos| 
      scaffold_positions.include?(pos)
    }
    is_intersection ? line * col : 0
  }
end

def amount_of_dust(ops, inputs)
  program = Program.new([2, *ops.drop(1)])

  input = inputs.flat_map{ |i| i.chars.map(&:ord) }

  final = nil

  until program.halted?
    out = program.run_ops(input)
    final = out unless out.nil?
  end
  final
end

unless ARGV.empty?
  ops = ARGV.first.split(',').map(&:to_i)
  puts sum_of_alignment_parameters(ops)
  puts amount_of_dust(ops, [
    "A,A,B,C,B,C,B,C,B,A\n",
    "R,6,L,12,R,6\n",
    "L,12,R,6,L,8,L,12\n",
    "R,12,L,10,L,10\n",
    "n\n",
  ])
end
