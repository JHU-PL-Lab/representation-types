
defmodule Lambda1 do

  def var(id),       do: {:Var, id}
  def lam(id, body), do: {:Lam, id, body}
  def apl(lhs, rhs), do: {:Apl, lhs, rhs}

  def subst(var, val, term) do
    case term do
      {:Lam, ^var, _} -> term
      {:Lam, id, body} -> lam(id, subst(var, val, body))

      {:Var, ^var} -> val
      {:Var, _} -> term

      {:Apl, lhs, rhs} ->
        apl(subst(var, val, lhs), subst(var, val, rhs))
    end
  end

  def eval(term) do
    case term do
      {:Lam, _, _} -> term
      {:Apl, lhs, rhs} ->
        {:Lam, arg, body} = eval(lhs)
        rhs = eval(rhs)
        eval(subst(arg, rhs, body))
    end
  end

  def succ, do: lam(1, lam(2, lam(3,
    apl(var(2), apl( apl(var(1), var(2)), var(3) ))
  )))

  def add, do: lam(1, lam(2,
    apl( apl(var(1), succ() ), var(2) )
  ))

  def mul, do: lam(1, lam(2, lam(3,
    apl( var(1), apl(var(2), var(3)) )
  )))

  def pred, do: lam(1, lam(2, lam(3,
    apl(
        apl(
            apl( var(1), lam(4, lam(5, apl(var(5), apl(var(4), var(2))))) ),
            lam(6, var(3))
        ),
        lam(6, var(6))
    )
  )))

  def sub, do: lam(1, lam(2,
    apl( apl(var(2), pred()), var(1) )
  ))

  def church(0), do: lam(0, lam(1, var(1)))
  def church(n) do
    apl(succ(), church(n - 1))
  end

  def identity, do:
    lam(0, apl( apl(var(0), succ()), church(0) ))



	def get_input() do
		IO.binread(:line)
			|> String.trim()
			|> String.to_integer
	end

  def main() do
    n = get_input()

    one = apl( apl(sub(), church(n)), church(n - 1) )

    IO.puts(
      inspect( eval(apl(identity(), one)) )
    )
  end

end


Lambda1.main()
