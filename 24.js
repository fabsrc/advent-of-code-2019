function calculateBiodiversityRating(area) {
  let state = area;
  const states = new Set([state]);
  const getNeighborIncrement = (val) => (val === "#" ? 1 : 0);

  while (true) {
    const newState = [];

    state.forEach((row, i) => {
      row.forEach((space, j) => {
        newState[i] = newState[i] || [];
        let adjacentBugCount = 0;
        adjacentBugCount += getNeighborIncrement((state[i - 1] || [])[j]);
        adjacentBugCount += getNeighborIncrement((state[i] || [])[j - 1]);
        adjacentBugCount += getNeighborIncrement((state[i] || [])[j + 1]);
        adjacentBugCount += getNeighborIncrement((state[i + 1] || [])[j]);

        if (space === "#" && adjacentBugCount !== 1) {
          newState[i][j] = ".";
        } else if (
          space === "." &&
          (adjacentBugCount === 1 || adjacentBugCount === 2)
        ) {
          newState[i][j] = "#";
        } else {
          newState[i][j] = space;
        }
      });
    });

    state = newState;
    const stringifiedState = JSON.stringify(state);
    if (states.has(stringifiedState)) {
      break;
    }
    states.add(stringifiedState);
  }

  const biodiversityRating = state
    .flat()
    .reduce((score, space, idx) => (score += space === "#" ? 2 ** idx : 0), 0);

  return biodiversityRating;
}

function numberOfBugsAfterTime(area, minutes) {
  let bugs = new Set();

  area.forEach((row, y) => {
    row.forEach((space, x) => {
      if (space === "#") {
        bugs.add(`${x},${y},0`);
      }
    });
  });

  function getNeighborCount(x, y, z) {
    let count = 0;

    if (x === 0 && bugs.has(`1,2,${z - 1}`)) count++;
    if (x === 4 && bugs.has(`3,2,${z - 1}`)) count++;
    if (y === 0 && bugs.has(`2,1,${z - 1}`)) count++;
    if (y === 4 && bugs.has(`2,3,${z - 1}`)) count++;

    if (x === 1 && y === 2) {
      for (let cy = 0; cy < 5; cy++) {
        if (bugs.has(`0,${cy},${z + 1}`)) count++;
      }
    }
    if (x === 3 && y === 2) {
      for (let cy = 0; cy < 5; cy++) {
        if (bugs.has(`4,${cy},${z + 1}`)) count++;
      }
    }
    if (x === 2 && y === 1) {
      for (let cx = 0; cx < 5; cx++) {
        if (bugs.has(`${cx},0,${z + 1}`)) count++;
      }
    }
    if (x === 2 && y === 3) {
      for (let cx = 0; cx < 5; cx++) {
        if (bugs.has(`${cx},4,${z + 1}`)) count++;
      }
    }

    if (bugs.has(`${x - 1},${y},${z}`)) count++;
    if (bugs.has(`${x + 1},${y},${z}`)) count++;
    if (bugs.has(`${x},${y - 1},${z}`)) count++;
    if (bugs.has(`${x},${y + 1},${z}`)) count++;

    return count;
  }

  do {
    let nextBugs = new Set();

    const levels = Array.from(bugs).map((bug) => Number(bug.split(",")[2]));
    const minZ = Math.min(...levels);
    const maxZ = Math.max(...levels);

    for (let z = minZ - 1; z <= maxZ + 1; z++) {
      for (let y = 0; y < 5; y++) {
        for (let x = 0; x < 5; x++) {
          if (x === 2 && y === 2) {
            continue;
          }

          const neighbourCount = getNeighborCount(x, y, z);

          if (bugs.has(`${x},${y},${z}`)) {
            if (neighbourCount === 1) {
              nextBugs.add(`${x},${y},${z}`);
            }
          } else if (neighbourCount === 1 || neighbourCount === 2) {
            nextBugs.add(`${x},${y},${z}`);
          }
        }
      }
    }

    bugs = nextBugs;
  } while (--minutes > 0);

  return bugs.size;
}

console.assert(
  calculateBiodiversityRating([
    [".", ".", ".", ".", "#"],
    ["#", ".", ".", "#", "."],
    ["#", ".", ".", "#", "#"],
    [".", ".", "#", ".", "."],
    ["#", ".", ".", ".", "."],
  ]) === 2129920
);

console.assert(
  numberOfBugsAfterTime(
    [
      [".", ".", ".", ".", "#"],
      ["#", ".", ".", "#", "."],
      ["#", ".", ".", "#", "#"],
      [".", ".", "#", ".", "."],
      ["#", ".", ".", ".", "."],
    ],
    10
  ) === 99
);

if (process.argv[2]) {
  const area = process.argv[2].split("\n").map((line) => line.split(""));
  console.log(calculateBiodiversityRating(area));
  console.log(numberOfBugsAfterTime(area, 200));
}
