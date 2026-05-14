# witomat

General subtraction game solver using backward induction (dynamic programming).

## Usage

```python
from python.backward import backward

S = {1, 3, 4}
result = backward(S, 20)
# result[i] = maximal winning move from i stones, or -1 if losing
```

CLI:

```bash
python3 python/backward.py 30 1,3,4
```
