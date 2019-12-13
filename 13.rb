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

  def run_ops(input = 0)
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

def get_number_of_blocks(ops)
  program = Program.new(ops)
  block_count = 0

  until program.halted?
    x = program.run_ops
    y = program.run_ops
    id = program.run_ops
    block_count += 1 if id == 2
  end

  block_count
end

def get_final_score(ops)
  program = Program.new([2, *ops[1..]])
  paddle_pos_x = 0
  ball_pos_x = 0
  current_score = 0

  until program.halted?
    input = 0

    if ball_pos_x > paddle_pos_x
      input = 1
    elsif ball_pos_x < paddle_pos_x
      input = -1
    end

    x = program.run_ops(input)
    y = program.run_ops(input)
    id = program.run_ops(input)

    paddle_pos_x = x if id == 3
    ball_pos_x = x if id == 4
    current_score = id if x == -1 && y == 0
  end

  current_score
end

unless ARGV.empty?
  ops = ARGV.first.split(',').map(&:to_i)
  puts get_number_of_blocks(ops)
  puts get_final_score(ops)
end
