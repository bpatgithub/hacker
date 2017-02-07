class Node(object):
    def __init__(self, initdata = None, nextNode = None):
        self.data = initdata
        self.nextNode = nextNode

    def getData(self):
        return self.data

    def getNext(self):
        return self.nextNode

    def setData(self, newdata):
        self.data = newdata

    def setNext(self, newnext):
        self.nextNode = newnext

class SinglyLList(object):
    def __init__(self):
        self.head = None  # There is only one head for the whole list.

    def isEmpty(self):
        return self.head == None

    def add(self, data):
        newNode = Node(data)
        # Assign new Node next to point to head of the current list.  Remember head is for list only, not node.
        newNode.nextNode = self.head

        # Now head should point to this new Node, so that becomes top of the list.  Here "self" is for the linked list object, not node.
        self.head = newNode

    def printList(self):
        current = self.head

        while (current != None):
            print(current.getData())
            current = current.nextNode

    def size(self):
        current = self.head
        count = 0
        while (current != None):
            count += 1
            current = current.nextNode
        return count

    def search(self, data):
        current = self.head

        while (current != None):
            if (current.getData() == data):
                return True
            else:
                current = current.nextNode

        return False

    def remove(self, data):
        current = self.head
        previous = None
        found = False

        while (current != None and found == False):
            if (current.getData() == data):
                found = True
            else:
                previous = current
                current = current.nextNode

        if previous == None:
            self.head = current.nextNode
        else:
            previous.nextNode = current.nextNode

myList=SinglyLList()
print(myList.isEmpty())  # True

myList.add(23)
myList.add(25)
myList.add(27)
myList.add(29)

myList.printList()
print(myList.size())
print(myList.search(35))

# lets remove a node.
myList.remove(27)
myList.printList()
