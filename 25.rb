class Droid
  def initialize(ops)
    @pos = 0
    @ops = ops.dup
    @relative_base = 0
    @output = []
    @input = []
  end

  def run()
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
        return
      when 1
        @ops[param_3] = get_op(param_1) + get_op(param_2)
        @pos += 4
      when 2
        @ops[param_3] = get_op(param_1) * get_op(param_2)
        @pos += 4
      when 3
        input = @input.shift
        break unless input
        @ops[param_1] = input
        @pos += 2
      when 4
        out = get_op(param_1)
        @output << out
        @pos += 2

        if out == 10
          text = @output.map(&:chr).join('')
          @output = []
          puts text
          
          if text.chomp == "Command?"
            puts "Choices: 'take', 'drop', 'inv' or movement"
            @input = STDIN.gets.chars.map(&:ord)
          end
        end
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

unless ARGV.empty?
  ops = ARGV.first.split(",").map(&:to_i)
  Droid.new(ops).run
end
