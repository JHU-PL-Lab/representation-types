
defmodule Pascal do

  def getNumber(row, col) do
    if col == 0 or row == 0 or row == col do
      1
    else
      getNumber(row - 1, col - 1) + getNumber(row - 1, col)
    end
  end

  def read_int() do
    IO.binread(:line)
      |> String.trim()
      |> String.to_integer
  end

  def main() do
    row = read_int()
    col = read_int()

    IO.inspect(getNumber(row, col))
  end

end

Pascal.main()
