function matrix1by3(a) {
    return [a[0], a[1], a[2]];
}

function matrix3by3(a, b, c) {
    return [a, b, c];
}

function matrix3by3_get_col_1(a) {
    return [a[0][0], a[1][0], a[2][0]];
}

function matrix3by3_get_col_2(a) {
    return [a[0][1], a[1][1], a[2][1]];
}

function matrix3by3_get_col_3(a) {
    return [a[0][2], a[1][2], a[2][2]];
}

function multiply1by3_by_scalar(a, x) {
    return [a[0]*x, a[1]*x, a[2]*x];
}

function multiply3by3_by_scalar(a, x) {
    return [multiply1by3_by_scalar(a[0], x), 
    multiply1by3_by_scalar(a[1], x), multiply1by3_by_scalar(a[2], x)];
}

function dot_product_tuple3(a, b) {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

function multiply1by3_by_3by3(a, b) {
    return [dot_product_tuple3(a, matrix3by3_get_col_1(b)), dot_product_tuple3(a, matrix3by3_get_col_2(b)), dot_product_tuple3(a, matrix3by3_get_col_3(b))];
}

function multiply3by3_by_3by3(a, b) {
    return [multiply1by3_by_3by3(a[0], b), multiply1by3_by_3by3(a[1], b), multiply1by3_by_3by3(a[2], b)]
}

i = -9999
limit = 10000

function loop() {
    if (i < limit) {
        matrix_row = [i, i, i]
        matrix1 = matrix3by3(matrix_row, matrix_row, matrix_row)
        matrix2 = matrix3by3(matrix_row, matrix_row, matrix_row)
        multiply3by3_by_3by3(matrix1, matrix2)
        i += 1
        loop()
    }
}

loop()