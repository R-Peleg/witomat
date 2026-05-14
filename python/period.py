from collections.abc import Sequence


def period(seq: Sequence[int]) -> int | None:
    n = len(seq)
    for p in range(1, n):
        ok = True
        for i in range(p, n):
            if seq[i] != seq[i - p]:
                ok = False
                break
        if ok:
            return p
    return n if n > 0 else None


if __name__ == '__main__':
    import sys

    if len(sys.argv) < 2:
        print('Usage: python period.py <comma-separated 0s and 1s>')
        print('Example: python period.py 0,1,0,1,0,1')
        sys.exit(1)
    seq = [int(x) for x in sys.argv[1].split(',')]
    result = period(seq)
    print(f'period = {result}')
