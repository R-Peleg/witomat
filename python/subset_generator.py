from collections.abc import Iterator
from itertools import combinations


def subsets_of_5() -> Iterator[set[int]]:
    for r in range(1, 6):
        for combo in combinations(range(1, 6), r):
            yield set(combo)


def all_subsets() -> list[set[int]]:
    return list(subsets_of_5())
