def shuffle_deck(instructions, no_of_cards)
  deck = (0...no_of_cards).to_a

  instructions.each do |instruction|
    case instruction.chomp
    when "deal into new stack"
      deck.reverse!
    when /deal with increment (-?\d+)/
      increment = $1.to_i
      table = Array.new(no_of_cards, 0)
      pos = 0
      while deck.size > 0
        n = deck.shift
        table[pos] = n if n
        pos += increment
        pos = pos % no_of_cards if pos > no_of_cards
      end
      deck = table
    when /cut (-?\d+)/
      n = $1.to_i
      deck.rotate!(n)
    end
  end

  deck
end

raise unless shuffle_deck(["deal with increment 7",
                           "deal into new stack",
                           "deal into new stack"], 10) == [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]
raise unless shuffle_deck(["cut 6",
                           "deal with increment 7",
                           "deal into new stack"], 10) == [3, 0, 7, 4, 1, 8, 5, 2, 9, 6]
raise unless shuffle_deck(["deal with increment 7",
                           "deal with increment 9",
                           "cut -2"], 10) == [6, 3, 0, 7, 4, 1, 8, 5, 2, 9]
raise unless shuffle_deck(["deal into new stack",
                           "cut -2",
                           "deal with increment 7",
                           "cut 8",
                           "cut -4",
                           "deal with increment 7",
                           "cut 3",
                           "deal with increment 9",
                           "deal with increment 3",
                           "cut -1"], 10) == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]

def shuffle_deck_2(instructions)
  n = 119315717514047
  c = 2020

  a, b = 1, 0
  instructions.each do |instruction|
    case instruction.chomp
    when "deal into new stack"
      la, lb = -1, -1
    when /deal with increment (-?\d+)/
      i = $1.to_i
      la, lb = i, 0
    when /cut (-?\d+)/
      i = $1.to_i
      la, lb = 1, -i
    end

    a = (la * a) % n
    b = (la * b + lb) % n
  end

  m = 101741582076661

  inv = -> (a, n) { a.pow(n - 2, n) }

  ma = a.pow(m, n)
  mb = (b * (ma - 1) * inv.call(a - 1, n)) % n

  ((c - mb) * inv.call(ma, n)) % n
end

if ARGV.size > 0
  input = ARGV.first.lines
  puts shuffle_deck(input, 10007).index(2019)
  puts shuffle_deck_2(input)
end
