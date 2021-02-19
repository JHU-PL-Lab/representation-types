def determinant3by3(matrix):
    return [matrix[0][0] * (matrix[1][1]*matrix[2][2] - matrix[1][2]*matrix[2][1]), matrix[0][1] * (matrix[1][0]*matrix[2][2] - matrix[1][2]*matrix[2][0]), matrix[0][2] * (matrix[1][0]*matrix[2][1] - matrix[1][1]*matrix[2][0])]

matrix1 = [[1, 1, 1], [1, 1, 1], [1, 1, 1]]

for i in range(1000):
    for j in range(3):
        for k in range(3):
            determinant3by3(matrix1)
            matrix1[j][k] += 1            


