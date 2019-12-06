import sys


class Object:
    def __init__(self, id):
        self.id = id
        self.orbit_obj = None

    def __repr__(self):
        return self.id


def create_objs(orbit_map: list) -> dict:
    objs = dict()

    for data in orbit_map:
        id_1, id_2 = data.split(')')
        objs[id_1] = objs.get(id_1, Object(id_1))
        obj_2 = objs.get(id_2, Object(id_2))
        obj_2.orbit_obj = objs[id_1]
        objs[id_2] = obj_2

    return objs


def get_total_number_of_orbits(orbit_map: list) -> int:
    objs = create_objs(orbit_map)

    count = 0
    for obj in objs.values():
        while obj.orbit_obj:
            count += 1
            obj = obj.orbit_obj

    return count


assert get_total_number_of_orbits(["COM)B", "B)C", "C)D", "D)E",
                                   "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"]) == 42


def get_min_number_of_orbital_transfers(orbit_map: list) -> int:
    objs = create_objs(orbit_map)

    def get_orbital_transfer_path(obj: Object) -> set:
        path = set()
        while obj.orbit_obj:
            obj = obj.orbit_obj
            path.add(obj)
        return path

    you_path = get_orbital_transfer_path(objs['YOU'])
    san_path = get_orbital_transfer_path(objs['SAN'])

    return len(you_path.symmetric_difference(san_path))


assert get_min_number_of_orbital_transfers(["COM)B", "B)C", "C)D", "D)E",
                                            "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L", "K)YOU", "I)SAN"]) == 4

if len(sys.argv) > 1:
    input = sys.argv[1].splitlines()
    print(get_total_number_of_orbits(input))
    print(get_min_number_of_orbital_transfers(input))
