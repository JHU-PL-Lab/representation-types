
import math
import random
import sys


def log_lerp(a, b, t):
    la = math.log(a)
    lb = math.log(b)
    return math.exp(la + t*(lb - la))

def log_range_between(a, b, steps):
    for t in range(0, steps+1):
        yield log_lerp(a, b, t / steps) 




def random_nums(n):
    for _ in range(n):
        v = 0
        while v == 0:
            v = random.randint(- (n/2) - 1, (n / 2) + 1)
        yield v
    yield 0



