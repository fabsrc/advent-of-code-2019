import sys


def get_intersections(paths):
    board = dict()

    for path_no, path in enumerate(paths):
        x, y, step_count = 0, 0, 0

        for p in path.split(','):
            dir, steps_to_go = p[:1], int(p[1:])

            while steps_to_go > 0:
                board.setdefault((x, y), dict())[path_no] = step_count

                if dir == 'R':
                    x += 1
                elif dir == 'L':
                    x -= 1
                elif dir == 'U':
                    y += 1
                elif dir == 'D':
                    y -= 1

                steps_to_go -= 1
                step_count += 1

    intersections = {coords: visits for (
        coords, visits) in board.items() if len(visits.keys()) > 1 and coords != (0, 0)}
    return intersections


def min_distance_to_intersection(paths):
    intersections = get_intersections(paths)
    distances = [sum(map(abs, coords)) for coords in intersections.keys()]
    return min(distances)


assert min_distance_to_intersection(
    ["R8,U5,L5,D3", "U7,R6,D4,L4"]) == 6
assert min_distance_to_intersection(
    ["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]) == 159
assert min_distance_to_intersection(
    ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]) == 135


def min_steps_to_intersection(paths):
    intersections = get_intersections(paths)
    combined_steps = [sum(a.values()) for a in intersections.values()]
    return min(combined_steps)


assert min_steps_to_intersection(["R8,U5,L5,D3", "U7,R6,D4,L4"]) == 30
assert min_steps_to_intersection(
    ["R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83"]) == 610
assert min_steps_to_intersection(
    ["R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"]) == 410


if len(sys.argv) > 1:
    input = sys.argv[1].splitlines()
    print(min_distance_to_intersection(input))
    print(min_steps_to_intersection(input))
