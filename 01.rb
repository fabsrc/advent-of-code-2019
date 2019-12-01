def calculate_fuel(mass)
  mass / 3 - 2
end

raise unless calculate_fuel(12) == 2
raise unless calculate_fuel(14) == 2
raise unless calculate_fuel(1969) == 654
raise unless calculate_fuel(100756) == 33583

def calculate_additional_fuel(mass)
  fuel = calculate_fuel(mass)
  return fuel if calculate_fuel(fuel) <= 0
  fuel + calculate_additional_fuel(fuel)
end

raise unless calculate_additional_fuel(14) == 2
raise unless calculate_additional_fuel(1969) == 966
raise unless calculate_additional_fuel(100756) == 50346

unless ARGV.empty?
  masses = ARGV[0].lines.map(&:to_i)
  puts masses.sum(&method(:calculate_fuel))
  puts masses.sum(&method(:calculate_additional_fuel))
end
