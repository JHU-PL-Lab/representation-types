
import sys
from collections import namedtuple


Var = namedtuple("Var", "id")

Lam = namedtuple("Lam", "arg body")

Apl = namedtuple("Apl", "lhs rhs")


def subst(var, value, term):
    if isinstance(term, Var):
        if term.id == var:
            return value
        else:
            return term

    elif isinstance(term, Lam):
        if term.arg == var:
            return term
        else:
            return Lam(term.arg, subst(var, value, term.body))
    
    elif isinstance(term, Apl):
        return Apl(
            subst(var, value, term.lhs),
            subst(var, value, term.rhs),
        )


def eval(term):
    if isinstance(term, Lam):
        return term    
    elif isinstance(term, Apl):
        lhs = eval(term.lhs)
        rhs = eval(term.rhs)
        assert isinstance(lhs, Lam)
        return eval(subst(lhs.arg, rhs, lhs.body))


succ = Lam(1, Lam(2, Lam(3, 
    Apl(Var(2), Apl(Apl(Var(1), Var(2)), Var(3)))
)))

add = Lam(1, Lam(2,
    Apl(Apl(Var(1), succ), Var(2))
))

mul = Lam(1, Lam(2, Lam(3,
    Apl(Var(1), Apl(Var(2), Var(3)))
)))

pred = Lam(1, Lam(2, Lam(3,
    Apl(
        Apl(
            Apl( Var(1), Lam(4, Lam(5, Apl(Var(5), Apl(Var(4), Var(2))))) ),
            Lam(6, Var(3))
        ),
        Lam(6, Var(6))
    )
)))

sub = Lam(1, Lam(2, 
    Apl(Apl(Var(2), pred), Var(1))
))

def church(n):
    term = Lam(0, Lam(1, Var(1)))
    for _ in range(n):
        term = Apl(succ, term)
    return term

identity = Lam(0,
    Apl(Apl(Var(0), succ), church(0))
)

if __name__ == "__main__":
    n = int(input())
    one = Apl(Apl(sub, church(n)), church(n - 1))
    sys.setrecursionlimit(n * 10)
    print(eval(Apl(identity, one)))