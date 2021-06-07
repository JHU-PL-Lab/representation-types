

def is_triplet(a, b, c):
    return (a*a) + (b*b) == (c*c)


desired_sum = int(input())

for a in range(1, desired_sum):
    for b in range(a + 1, desired_sum):

        c = desired_sum - (a + b)
        if is_triplet(a, b, c):
            print(a, b, c)
            print(a * b * c)
            quit()
        