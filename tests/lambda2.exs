
defmodule Lambda2 do

  defmodule Var do
    defstruct [:id]
  end

  defmodule Lam do
    defstruct [:id, :body]
  end

  defmodule Apl do
    defstruct [:lhs, :rhs]
  end

  def var(id),       do: %Var{id: id}
  def lam(id, body), do: %Lam{id: id, body: body}
  def apl(lhs, rhs), do: %Apl{lhs: lhs, rhs: rhs}

  defprotocol Term do
    def subst(term, var, val)
    def eval(term)
    def apply(term, arg)
  end

  defimpl Term, for: Var do
    def subst(%Var{id: id}, id, val) do
      val
    end

    def subst(term, _, _) do
      term
    end

    def eval(_term) do
      raise("open expression")
    end

    def apply(_term, _arg) do
      raise("open expression")
    end
  end

  defimpl Term, for: Lam do
    def subst(term, var, val) do
      %Lam{id: id, body: body} = term
      if id == var do
        term
      else
        %Lam{id: id, body: Term.subst(body, var, val)}
      end
    end

    def eval(term) do
      term
    end

    def apply(%Lam{id: id, body: body}, arg) do
      Term.eval(Term.subst(body, id, arg))
    end
  end

  defimpl Term, for: Apl do
    def subst(term, var, val) do
      %Apl{
        lhs: Term.subst(term.lhs, var, val),
        rhs: Term.subst(term.rhs, var, val)
      }
    end

    def eval(term) do
      lhs = Term.eval(term.lhs)
      rhs = Term.eval(term.rhs)
      Term.apply(lhs, rhs)
    end

    def apply(_term, _arg) do
      raise("Cannot apply an Apl.")
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
      inspect( Term.eval(apl(identity(), one)) )
    )
  end

end


Lambda2.main()
