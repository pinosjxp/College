from pyliststack import Stack

# The private storage class for creating stack nodes.

class _Node():
    def __init__(self,item,color):
        self.item=item
        self.color=color
        
# Implementation of the red/black stack ADT using Stack ADT. 

class RedBlackStack():
    
# Creates an empty red/black stack.

    def __init__(self):
        self.RBStack=Stack()
        
# Returns true if the red/black stack is empty of false otherwise.

    def isEmpty(self):
        return (self.RBStack.isEmpty())
    
# Returns the number of items in the stack.

    def __len__(self):
        return len(self.RBStack)
    
# Pushes a node that stores item and color onto top of stack.

    def push(self, item, color):
        tmpColor=color.lower()
        assert(tmpColor=='r' or tmpColor=='b' or tmpColor=='black' or tmpColor=='red'),"Invalid color"
        tmpNode=_Node(item,color)
        self.RBStack.push(tmpNode)
        
# Removes the last node placed on top of stack based on input color, and returns item. 
# If color is None, removes last node placed on stack and returns item. 

    def pop(self,color=None):
        assert(not self.RBStack.isEmpty()),"Stack is Empty"
        if (color==None):
            return self.RBStack.pop().item
        tmpColor=color.lower()
        assert(tmpColor=='r' or tmpColor=='b' or tmpColor=='black' or tmpColor=='red'),"Invalid color"
        if(tmpColor=='r' or tmpColor=='red'):
            tmpStack=Stack()
            while(not self.RBStack.isEmpty()):
                tmpNode=self.RBStack.pop()
                if (tmpNode.color=='r' or tmpNode.color=='red'):
                    while(not tmpStack.isEmpty()):
                        self.RBStack.push(tmpStack.pop())
                    return tmpNode.item
                    break
                else:
                    tmpStack.push(tmpNode)
            while(not tmpStack.isEmpty()):
                self.RBStack.push(tmpStack.pop())
            assert(False),"Color item not found."
            
        else:
            tmpStack=Stack()
            while(not self.RBStack.isEmpty()):
                tmpNode=self.RBStack.pop()
                if (tmpNode.color=='b' or tmpNode.color=='black'):
                    while(not tmpStack.isEmpty()):
                        self.RBStack.push(tmpStack.pop())
                    return tmpNode.item
                    break
                else:
                    tmpStack.push(tmpNode)
            while(not tmpStack.isEmpty()):
                self.RBStack.push(tmpStack.pop())
            assert(False),"Color not found."
            
# Returns last item on stack based on color input without removing respected node.
# If color is None, returns last item placed on stack.

    def peek(self,color=None):
        assert(not self.RBStack.isEmpty()),"Stack is Empty"
        if (color==None):
            return self.RBStack.peek().item
        tmpColor=color.lower()
        assert(tmpColor=='r' or tmpColor=='b' or tmpColor=='black' or tmpColor=='red'),"Invalid color"
        if(tmpColor=='r' or tmpColor=='red'):
            tmpStack=Stack()
            while(not self.RBStack.isEmpty()):
                tmpNode=self.RBStack.peek()
                if (tmpNode.color=='r' or tmpNode.color=='red'):
                    while(not tmpStack.isEmpty()):
                        self.RBStack.push(tmpStack.pop())
                    return tmpNode.item
                    break
                else:
                    tmpStack.push(self.RBStack.pop())
            while(not tmpStack.isEmpty()):
                self.RBStack.push(tmpStack.pop())
            assert(False),"Color item not found."
            
        else:
            tmpStack=Stack()
            while(not self.RBStack.isEmpty()):
                tmpNode=self.RBStack.peek()
                if (tmpNode.color=='b' or tmpNode.color=='black'):
                    while(not tmpStack.isEmpty()):
                        self.RBStack.push(tmpStack.pop())
                    return tmpNode.item
                    break
                else:
                    tmpStack.push(self.RBStack.pop())
            while(not tmpStack.isEmpty()):
                self.RBStack.push(tmpStack.pop())
            assert(False),"Color not found."
