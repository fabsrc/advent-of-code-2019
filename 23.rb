class Computer
  attr_accessor :inputs
  attr_reader :outputs

  def initialize(ops, address)
    @pos = 0
    @ops = ops.dup
    @relative_base = 0
    @inputs = []
    @outputs = []
    @inputs << address
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
        input = @inputs.shift
        @ops[param_1] = input || -1
        @pos += 2
        return if @inputs.empty?
      when 4
        out = get_op(param_1)
        @outputs << out
        @pos += 2

        if @outputs.size === 3
          return @outputs.shift(3)
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

def run_network(ops)
  computers = (0...50).map { |address|
    Computer.new(ops, address)
  }

  loop do
    computers.each do |computer|
      res = computer.run
      unless res.nil?
        target, x, y = res
        return y if target == 255
        computers[target].inputs << x << y
        computers[target].run
      end
    end
  end
end

def run_network_with_nat(ops)
  computers = (0...50).map { |address|
    Computer.new(ops, address)
  }

  last_y = nil
  nat_packet = []

  loop do
    results = []

    computers.each do |computer|
      res = computer.run

      unless res.nil?
        results << res
        target, x, y = res

        if target == 255
          nat_packet = [x, y]
        else
          computers[target].inputs << x << y
          computers[target].run
        end
      end
    end

    if results.empty? && nat_packet.any?
      x, y = nat_packet.shift(2)

      return y if y == last_y

      computers[0].inputs << x << y
      computers[0].run
      last_y = y
    end
  end
end

unless ARGV.empty?
  ops = ARGV.first.split(",").map(&:to_i)
  puts run_network(ops)
  puts run_network_with_nat(ops)
end
