
defmodule Sorting do

  def read_input(l) do
    n = IO.binread(:line)
      |> String.trim()
      |> String.to_integer

    if n != 0 do
      read_input([n | l])
    else
      l
    end
  end

  def main() do
    input = read_input([])
    IO.inspect(Enum.sort(input))
  end

end


Sorting.main()
