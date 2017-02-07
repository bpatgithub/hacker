# Understanding construction and destructor for a class.
# Object are different than functions.
# Objects have both local data and methods unlike function have only methods.
# In following example, x, name are the local data set which is carried by the object.

class PartyAnimal:
    x = 0
    name = ""

    # now lets define constructor.
    # Constructor is optional.  Complier will perform that operation by itself if you don't.
    # all methods with __ are special.
    # self is just the point to the instant of the object.  That's always the first argument and it is optional.

    # you will see that I am constructed is displayed as soon as we execute the program.
    def __init__(self, nm):
        self.name = nm
        print "I am constructed ", self.name

    def party(self):
        self.x = self.x + 1
        print "So far ", self.x, "for", self.name

    #Destructor are optional too just like constructor.
    # you will see that when program ends, it will display I am destructed.

    def __del__(self):
        print "I am destructed"

# Now main block of the function.
# Create the class, just like calling function.
# This will now create an object and assigned to variable to s and another to j.

s = PartyAnimal("Sally")
s.party()

j = PartyAnimal("Jim")
j.party()
