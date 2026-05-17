from collections.abc import Iterable

from python.backward import backward
from python.period import period
from python.subset_generator import subsets_of_5


def main() -> None:
    n = 200
    results: list[tuple[int, set[int]]] = []

    for moves in subsets_of_5():
        def options_func(state: int, moves: set[int] = moves) -> Iterable[int]:
            return (state - s for s in moves if s <= state)

        dp = backward(options_func, n)
        seq = dp
        p = period(seq)
        if p is not None:
            results.append((p, moves))

    with_one = [(p, moves) for p, moves in results if 1 in moves]
    with_one.sort(key=lambda x: x[0], reverse=True)

    if not with_one:
        print("No results found with 1 included.")
        return

    best_p, best_moves = with_one[0]
    print(f"Longest Grundy period length with 1 included: {best_p}")
    print(f"Moves set: {sorted(best_moves)}")


if __name__ == "__main__":
    main()
