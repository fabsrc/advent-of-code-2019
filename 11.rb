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


def get_painted_area(ops, initial_color)
  program = Program.new(ops)  
  area = Hash.new
  cur_pos = [0,0]
  dirs = [[0,1], [1,0], [0,-1], [-1,0]]

  until program.halted?
    color = area[cur_pos] || initial_color
    out_color = program.run_ops(color)
    area[cur_pos.dup] = out_color
    out_dir = program.run_ops(color)
    dirs = dirs.rotate(out_dir == 1 ? 1 : - 1)
    cur_pos[0] += dirs.first[0]
    cur_pos[1] += dirs.first[1]
  end
  
  area
end

def get_painted_area_size(ops)
  area = get_painted_area(ops, 0)
  area.size
end

def render_painted_area(ops)
  area = get_painted_area(ops, 1)
  xmin, xmax = area.keys.map(&:first).minmax
  ymin, ymax = area.keys.map(&:last).minmax
  ymax.downto(ymin).each do |y|
    xmin.upto(xmax).each do |x|
      print(area[[x,y]] == 1 ? "#" : " ")
    end
    print("\n")
  end
end

unless ARGV.empty?
  ops = ARGV.first.split(',').map(&:to_i)
  puts get_painted_area_size(ops)
  render_painted_area(ops)
end
