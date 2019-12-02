function runOpcode (originalOps, noun, verb) {
  const ops = [...originalOps]
  ops[1] = noun || ops[1]
  ops[2] = verb || ops[2]

  let pos = 0

  while (true) {
    const op = ops[pos]

    if (op === 99) {
      break
    }
    if (op === 1) {
      ops[ops[pos + 3]] = ops[ops[pos + 1]] + ops[ops[pos + 2]]
    }
    if (op === 2) {
      ops[ops[pos + 3]] = ops[ops[pos + 1]] * ops[ops[pos + 2]]
    }

    pos += 4
  }

  return ops
}

console.assert(runOpcode([1, 0, 0, 0, 99]).join(',') === '2,0,0,0,99')
console.assert(runOpcode([2, 3, 0, 3, 99]).join(',') === '2,3,0,6,99')
console.assert(runOpcode([2, 4, 4, 5, 99, 0]).join(',') === '2,4,4,5,99,9801')
console.assert(
  runOpcode([1, 1, 1, 4, 99, 5, 6, 0, 99]).join(',') === '30,1,1,4,2,5,6,0,99'
)

if (process.argv[2]) {
  const ops = process.argv[2].split(',').map(Number)

  // Part 1
  console.log(runOpcode(ops, 12, 2)[0])

  // Part 2
  for (let noun = 0; noun < 100; noun++) {
    for (let verb = 0; verb < 100; verb++) {
      if (runOpcode(ops, noun, verb)[0] === 19690720) {
        console.log(100 * noun + verb)
        process.exit()
      }
    }
  }
}
