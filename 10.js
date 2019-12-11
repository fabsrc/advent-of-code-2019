function isBetween(a, b, c) {
  const crossproduct = (c.y - a.y) * (b.x - a.x) - (c.x - a.x) * (b.y - a.y);

  if (Math.abs(crossproduct) > Number.EPSILON) {
    return false;
  }

  const dotproduct = (c.x - a.x) * (b.x - a.x) + (c.y - a.y) * (b.y - a.y);
  if (dotproduct < 0) {
    return false;
  }

  const squaredlengthba = (b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y);
  if (dotproduct > squaredlengthba) {
    return false;
  }

  return true;
}

function getAngle(a, b, rotation = 180) {
  const angle = (180 / Math.PI) * Math.atan2(b.x - a.x, b.y - a.y) - rotation;
  return angle % 360;
}

function getDistance(a, b) {
  return Math.hypot(b.x - a.x, b.y - a.y);
}

function getAsteroids(rawMap) {
  const map = rawMap.split("\n").map(row => row.split(""));

  const asteroids = [];
  for (let y = 0; y < map.length; y++) {
    for (let x = 0; x < map[y].length; x++) {
      if (map[y][x] === "#") {
        asteroids.push({ x, y });
      }
    }
  }
  return asteroids;
}

function findBestLocation(rawMap) {
  const asteroids = getAsteroids(rawMap);
  const counts = asteroids.map(cur => {
    const curAsteroids = new Set(asteroids);
    curAsteroids.delete(cur);
    curAsteroids.forEach(a => {
      curAsteroids.forEach(b => {
        if (a != b && isBetween(cur, a, b)) {
          curAsteroids.delete(a);
        }
      });
    });
    return curAsteroids.size;
  });

  return Math.max(...counts);
}

console.assert(
  findBestLocation(`.#..#
.....
#####
....#
...##`) === 8
);
console.assert(
  findBestLocation(`......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####`) === 33
);
console.assert(
  findBestLocation(`#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.`) === 35
);
console.assert(
  findBestLocation(`.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..`) === 41
);
console.assert(
  findBestLocation(`.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##`) === 210
);

function find200thVaporizedAsteroid(rawMap) {
  const asteroids = getAsteroids(rawMap);
  const counts = asteroids.map(cur => {
    const curAsteroids = new Set(asteroids);
    curAsteroids.delete(cur);
    curAsteroids.forEach(a => {
      curAsteroids.forEach(b => {
        if (a != b && isBetween(cur, a, b)) {
          curAsteroids.delete(a);
        }
      });
    });
    return curAsteroids.size;
  });
  const max = Math.max(...counts);
  const maxIdx = counts.indexOf(max);
  const base = asteroids[maxIdx];

  const s = new Set(asteroids);
  s.delete(base);
  const res = Array.from(s).map(a => {
    return {
      coords: a,
      angle: getAngle(base, a),
      distance: getDistance(base, a)
    };
  });
  const sorted = res.sort((a, b) => b.angle - a.angle);
  const grouped = sorted.reduce((rv, x) => {
    (rv[x.angle] = rv[x.angle] || []).push(x);
    return rv;
  }, {});
  for (angle in grouped) {
    grouped[angle] = grouped[angle].sort((a, b) => a.distance - b.distance);
  }

  let count = 1;
  for (let objects of Object.values(grouped)) {
    if (count === 200) {
      const res = objects.shift();
      return res.coords.x * 100 + res.coords.y;
    }

    objects.shift();
    count++;
  }
}

console.assert(
  find200thVaporizedAsteroid(`.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##`) === 802
);

if (process.argv[2]) {
  console.log(findBestLocation(process.argv[2]));
  console.log(find200thVaporizedAsteroid(process.argv[2]));
}
