#Get the number at a specified row and column in Pascal's triangle

def getNumber(row, column):
    if column == 0:
        return 1
    elif column == row:
        return 1
    elif row == 0:
        return 1
    else:
        return getNumber(row - 1, column - 1) + getNumber(row - 1, column)

x = getNumber(100, 10)
print(x)