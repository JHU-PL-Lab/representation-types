import math

def mod(a, b):
    if a < b:
        return a
    else:
        return a - b*(a//b)

def isPrime(x):
    for i in range(3, math.floor(x/2)):
            if mod(x, i) == 0:
                return False
    return True


def getNthPrimeNumber(n):
    count = 4
    prime = 7
    while count < n:
        prime += 2
        if (isPrime(prime)):
            count += 1
    return prime

p = getNthPrimeNumber(1000000)
#print(p)