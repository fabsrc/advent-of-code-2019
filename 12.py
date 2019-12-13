import sys
import re
import itertools


class Moon:
    def __init__(self, px, py, pz):
        self.positions = [px, py, pz]
        self.velocities = [0, 0, 0]

    def apply_gravity(self, other_moon):
        for axis in range(3):
            if self.positions[axis] > other_moon.positions[axis]:
                self.velocities[axis] -= 1
                other_moon.velocities[axis] += 1
            elif self.positions[axis] < other_moon.positions[axis]:
                self.velocities[axis] += 1
                other_moon.velocities[axis] -= 1

    def apply_velocity(self):
        for axis in range(3):
            self.positions[axis] += self.velocities[axis]

    def get_total_energy(self):
        return sum(abs(pos) for pos in self.positions) * sum(abs(vlc) for vlc in self.velocities)


def get_moons(moon_inputs):
    positions = [(int(s) for s in re.findall(r'-?\d+', line))
                 for line in moon_inputs]
    moons = [Moon(*pos) for pos in positions]
    return moons


def run_step(moons):
    for moon, other_moon in itertools.combinations(moons, 2):
        moon.apply_gravity(other_moon)

    for moon in moons:
        moon.apply_velocity()


def get_total_energy(moon_inputs, steps):
    moons = get_moons(moon_inputs)

    for step in range(0, steps):
        run_step(moons)

    return sum(moon.get_total_energy() for moon in moons)


assert get_total_energy([
    "<x=-1, y=0, z=2>",
    "<x=2, y=-10, z=-7>",
    "<x=4, y=-8, z=8>",
    "<x=3, y=5, z=-1>"
], 10) == 179
assert get_total_energy([
    "<x=-8, y=-10, z=0>",
    "<x=5, y=5, z=10>",
    "<x=2, y=-7, z=3>",
    "<x=9, y=-8, z=-3>"
], 100) == 1940


def gcd(a, b):
    while b > 0:
        a, b = b, a % b
    return a


def lcm(a, b):
    return a * b // gcd(a, b)


def get_steps_until_repetition(moon_inputs):
    moons = get_moons(moon_inputs)
    seen_states = [set(), set(), set()]
    periods = [None, None, None]
    steps = 0

    while True:
        cur_states = [list(), list(), list()]

        for moon in moons:
            for axis in range(3):
                cur_states[axis].append(moon.positions[axis])
                cur_states[axis].append(moon.velocities[axis])

        run_step(moons)

        for axis in range(3):
            if periods[axis] is None and str(cur_states[axis]) in seen_states[axis]:
                periods[axis] = steps
            seen_states[axis].add(str(cur_states[axis]))

        if (all(period is not None for period in periods)):
            break
        
        steps += 1

    return lcm(lcm(periods[0], periods[1]), periods[2])


assert get_steps_until_repetition([
    "<x=-1, y=0, z=2>",
    "<x=2, y=-10, z=-7>",
    "<x=4, y=-8, z=8>",
    "<x=3, y=5, z=-1>"
]) == 2772
assert get_steps_until_repetition([
    "<x=-8, y=-10, z=0>",
    "<x=5, y=5, z=10>",
    "<x=2, y=-7, z=3>",
    "<x=9, y=-8, z=-3>"
]) == 4686774924

if len(sys.argv) > 1:
    input = sys.argv[1].splitlines()
    print(get_total_energy(input, 1000))
    print(get_steps_until_repetition(input))
