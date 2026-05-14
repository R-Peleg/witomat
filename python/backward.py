from collections.abc import Set


def backward(moves: Set[int], n: int) -> list[int]:
    dp = [-1] * n
    sorted_moves = sorted(moves, reverse=True)
    for i in range(1, n):
        for s in sorted_moves:
            if s <= i and dp[i - s] == -1:
                dp[i] = s
                break
    return dp


if __name__ == '__main__':
    import sys

    if len(sys.argv) < 3:
        print('Usage: python backward.py <n> <S: comma-separated>')
        print('Example: python backward.py 20 1,3,4')
        sys.exit(1)
    n = int(sys.argv[1])
    s_set = {int(x) for x in sys.argv[2].split(',')}
    result = backward(s_set, n)
    for i, val in enumerate(result):
        status = 'W' if val != -1 else 'L'
        print(f'dp[{i}] = {val} ({status})')
