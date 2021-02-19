//Get the number at a specified row and column in Pascal's triangle
//Rows and columns start from 0

function getNumber(row, column) {
    if (column == 0) {
        return 1;
    } else if (column == row) {
        return 1;
    } else if (row == 0) {
        return 1;
    } else {
        return getNumber(row - 1, column - 1) + getNumber(row - 1, column);
    }

}

getNumber(10000, 5000);