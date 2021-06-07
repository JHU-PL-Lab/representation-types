

def read_input():
    l = []
    n = int(input())
    while n != 0:
        l.append(n)
        n = int(input())
    return l


print(sorted(read_input()))