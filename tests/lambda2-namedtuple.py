
import sys
from collections import namedtuple

class Var(namedtuple("Var", "id")):
    
    def subst(self, var, val):
        if self.id == var:
            return val
        else:
            return self

    
class Lam(namedtuple("Lam", "arg body")):

    def subst(self, var, val):
        if self.arg == var:
            return self
        else:
            return Lam(self.arg, self.body.subst(var, val))

    def eval(self):
        return self

    def apply(self, arg):
        return self.body.subst(self.arg, arg).eval()


class Apl(namedtuple("Arg", "lhs rhs")):

    def subst(self, var, val):
        return Apl(
            self.lhs.subst(var, val),
            self.rhs.subst(var, val)
        )

    def eval(self):
        lhs = self.lhs.eval()
        rhs = self.rhs.eval()
        return lhs.apply(rhs)



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


n = int(input())

one = Apl(Apl(sub, church(n)), church(n - 1))

sys.setrecursionlimit(n * n)

print(Apl(identity, one).eval())