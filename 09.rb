def run_ops(ops, input = 0)
  @pos = 0
  @ops = ops.dup
  @relative_base = 0
  @out = nil

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
      return @out
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
      # puts "> #{@out}"
      @pos += 2
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

# puts run_ops([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
# puts run_ops([1102,34915192,34915192,7,4,7,99,0])
# puts run_ops([104,1125899906842624,99])

unless ARGV.empty?
  ops = ARGV[0].split(',').map(&:to_i)
  puts run_ops(ops, 1)
  puts run_ops(ops, 2)
end
