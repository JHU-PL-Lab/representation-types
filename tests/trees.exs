
defmodule Trees do

	def blacken(node) do
		case node do
			{:Red, data} -> {:Blk, data}
			other        -> other
		end
	end

	def get_value(node) do
		case node do
			{:Red, data} -> data.value
      {:Blk, data} -> data.value
		end
	end

	def map_data(node, f) do
		case node do
			{:Red, data} -> {:Red, f.(data)}
			{:Blk, data} -> {:Blk, f.(data)}
		end
	end

	def balance(tree = {:Blk, data}) do
		case data do
			%{l: {:Red, l = %{r: {:Red, lr}}}} ->
				{:Red, %{
					value: lr.value,
					l: {:Blk, %{
						value: l.value,
						l: l.l,
						r: lr.l, 
					}},
					r: {:Blk, %{
						value: data.value,
						l: lr.r,
						r: data.r,
					}},
				}}

			%{r: {:Red, r = %{r: {:Red, _}}}} ->
				{:Red, %{
					value: r.value,
					l: {:Blk, %{
						value: data.value,
						l: data.l,
						r: r.l,
					}},
					r: blacken(r.r),
				}}

			%{r: {:Red, r = %{l: {:Red, rl}}}} ->
        {:Red, %{
					value: rl.value,
					l: {:Blk, %{
						value: data.value,
						l: data.l,
						r: rl.l,
					}},
					r: {:Blk, %{
						value: r.value,
						l: rl.r, 
						r: r.r,
					}},
				}}

			
			%{l: {:Red, l = %{l: {:Red, _}}}} ->
				{:Red, %{
					value: l.value,
					l: blacken(l.l),
					r: {:Blk, %{
						value: data.value,
						r: data.r,
						l: l.r,
					}},
				}}

      _ -> tree
		end
	end

	def balance(tree), do: tree

	def insert(val, tree) do
		case tree do
			:Empty -> {:Red, %{value: val, l: :Empty, r: :Empty}}
			_ ->
				tree_val = get_value(tree)
				cond do
					val < tree_val ->
						balance(tree |> map_data(fn data -> %{ data | l: insert(val, data.l) } end))

					val == tree_val -> tree

					val > tree_val ->
						balance(tree |> map_data(fn data -> %{ data | r: insert(val, data.r) } end))
				end
		end
	end

  def count_red(:Empty), do: 0
  def count_red({:Red, data}) do
    1 + count_red(data.l) + count_red(data.r)
  end
  def count_red({:Blk, data}) do
    count_red(data.l) + count_red(data.r)
  end


	def get_input() do
		IO.binread(:line)
			|> String.trim()
			|> String.to_integer
	end

	def loop(tree) do
    n = get_input()
    if n == 0 do
      IO.puts(inspect(count_red(tree)))
    else
      loop(blacken(insert(n, tree)))
    end
  end

end

Trees.loop(:Empty)