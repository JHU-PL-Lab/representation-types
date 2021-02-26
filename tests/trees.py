
import enum
from dataclasses import dataclass, replace

class Color(enum.Enum):
    RED   = enum.auto()
    BLACK = enum.auto()


@dataclass
class Node:
    color: Color
    value: int
    left:  'Node' = None
    right: 'Node' = None

    @staticmethod
    def blacken(node) -> 'Node':
        if node is None: return None
        return replace(node, color = Color.BLACK)

    def balance(self) -> 'Node':
        if self.color is Color.RED: return self

        if self.left is not None and \
           self.left.color is Color.RED and \
           self.left.right is not None and \
           self.left.right.color is Color.RED:

           return Node(Color.RED,
                self.left.right.value,
                left = Node(Color.BLACK,
                    self.left.value,
                    left  = self.left.left,
                    right = self.left.right.left,
                ),
                right = Node(Color.BLACK,
                    self.value,
                    left  = self.left.right.right,
                    right = self.right,
                ),
           )
        
        if self.right is not None and \
           self.right.color is Color.RED and \
           self.right.right is not None and \
           self.right.right.color is Color.RED:

            return Node(Color.RED,
                self.right.value,
                left = Node(Color.BLACK,
                    self.value,
                    left  = self.left,
                    right = self.right.left,
                ),
                right = Node.blacken(self.right.right),
            )

        if self.right is not None and \
           self.right.color is Color.RED and \
           self.right.left is not None and \
           self.right.left.color is Color.RED:

           return Node(Color.RED,
                self.right.left.value,
                left = Node(Color.BLACK,
                    self.value,
                    left  = self.left,
                    right = self.right.left.left,
                ),
                right = Node(Color.BLACK,
                    self.right.value,
                    left  = self.right.left.right,
                    right = self.right.right,
                ),
           )
        
        if self.left is not None and \
           self.left.color is Color.RED and \
           self.left.left is not None and \
           self.left.left.color is Color.RED:

            return Node(Color.RED,
                self.left.value,
                left  = Node.blacken(self.left.left),
                right = Node(Color.BLACK,
                    self.value,
                    left  = self.left.right,
                    right = self.right,
                ),
            )

        return self



def insert(node, value: int) -> 'Node':
    if node is None: return Node(Color.RED, value, None, None)

    elif value < node.value:
        return replace(node, left = insert(node.left, value)).balance()
    elif value == node.value:
        return node
    else: # value > node.value:
        return replace(node, right = insert(node.right, value)).balance()


def count_red(node) -> int:
    if node is None:
        return 0
    elif node.color is Color.RED:
        return 1 + count_red(node.left) + count_red(node.right)
    else: # node.color is Color.BLACK
        return count_red(node.left) + count_red(node.right)


if __name__ == "__main__":

    tree = None

    while (value := int(input())) != 0:
        tree = Node.blacken(insert(tree, value))

    print(count_red(tree))