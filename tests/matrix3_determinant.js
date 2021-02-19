function determinant3by3(matrix) {
    return [matrix[0][0] * (matrix[1][1]*matrix[2][2] - matrix[1][2]*matrix[2][1]), matrix[0][1] * (matrix[1][0]*matrix[2][2] - matrix[1][2]*matrix[2][0]), matrix[0][2] * (matrix[1][0]*matrix[2][1] - matrix[1][1]*matrix[2][0])];
}

var matrix1 = [[1, 1, 1], [1, 1, 1], [1, 1, 1]]

for (var i=0; i<1000; i++) {
    for (var j=0; j<3; j++) {
        for (var k=0; k<3; k++) {
            determinant3by3(matrix1);
            matrix1[j][k] += 1;
        }
    }
}