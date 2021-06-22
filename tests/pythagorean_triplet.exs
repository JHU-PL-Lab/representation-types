
defmodule Pythagoras do

  def find(sum) do
    for a <- 1 .. (sum - 1) do
      for b <- a+1 .. (sum - 1) do

        c = sum - (a + b)
        if (a*a) + (b*b) == (c*c) do
          IO.inspect({a, b, c})
          IO.inspect(a * b * c)
          exit(:normal)
        end

      end
    end
  end

  def main() do
    desired_sum = IO.binread(:line)
      |> String.trim()
      |> String.to_integer

    find(desired_sum)
  end

end

Pythagoras.main()
