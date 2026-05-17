from collections.abc import Callable, Iterable, Set


def mex(vals: Set[int]) -> int:
    res = 0
    while res in vals:
        res += 1
    return res


def backward(options_func: Callable[[int], Iterable[int]], n: int) -> list[int]:
    dp = [0] * n
    for i in range(1, n):
        options_vals = {dp[next_state] for next_state in options_func(i)}
        dp[i] = mex(options_vals)
    return dp


if __name__ == '__main__':
    import sys

    if len(sys.argv) < 3:
        print('Usage: python backward.py <n> <S: comma-separated>')
        print('Example: python backward.py 20 1,3,4')
        sys.exit(1)
    n = int(sys.argv[1])
    s_set = {int(x) for x in sys.argv[2].split(',')}

    def subtraction_game(state: int) -> list[int]:
        return [state - s for s in s_set if s <= state]

    result = backward(subtraction_game, n)
    for i, val in enumerate(result):
        print(f'g({i}) = {val}')
