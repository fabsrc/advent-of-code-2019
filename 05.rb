def run_ops(original_ops, input)
  ops = original_ops.dup

  pos = 0
  out = 0
  loop do
    unless out == 0
      return out if ops[pos] == 99
      raise 'ERROR'
    end

    op_digits = ops[pos].to_s.chars
    op_code = op_digits.last(2).join.to_i
    modes = op_digits[0...-2].reverse.map(&:to_i)
    mode_1 = modes[0] || 0
    mode_2 = modes[1] || 0
    mode_3 = modes[2] || 0
    param_1 = mode_1 == 1 ? pos + 1 : ops[pos + 1]
    param_2 = mode_2 == 1 ? pos + 2 : ops[pos + 2]
    
    case op_code
    when 99
      break
    when 1
      ops[ops[pos + 3]] = ops[param_1] + ops[param_2]
      pos += 4
    when 2
      ops[ops[pos + 3]] = ops[param_1] * ops[param_2]
      pos += 4
    when 3
      ops[ops[pos + 1]] = input
      pos += 2
    when 4
      out = ops[param_1]
      pos += 2
    when 5
      pos = ops[param_1] != 0 ? ops[param_2] : pos + 3
    when 6
      pos = ops[param_1] == 0 ? ops[param_2] : pos + 3
    when 7
      ops[ops[pos + 3]] = ops[param_1] < ops[param_2] ? 1 : 0
      pos += 4
    when 8
      ops[ops[pos + 3]] = ops[param_1] == ops[param_2] ? 1 : 0
      pos += 4
    end
  end
end

unless ARGV.empty?
  ops = ARGV[0].split(',').map(&:to_i)
  puts run_ops(ops, 1)
  puts run_ops(ops, 5)
end
