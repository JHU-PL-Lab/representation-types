#Get the number at a specified row and column in Pascal's triangle

def getNumber(row, column):
    if (column == 0) or (row == 0) or (column == row):
        return 1
    else:
        return getNumber(row - 1, column - 1) + getNumber(row - 1, column)

row = int(input())
col = int(input())

print(getNumber(row, col))