# Understanding inheritance.

#
class PartyAnimal:
    # this class has two local data store x and name.
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

# Now lets create subclass which inherits from PartyAnimal.
class FootballFan(PartyAnimal):
    # this subclass has its own local data store for points.
    points = 0

    # this subclass also has its own local method, which is more stuff than parent class.
    def touchdown(self):
        self.points += 7
        print self.name, "has points ", self.points

# Now main block of the function.
# Create the class, just like calling function.
# This will now create an object and assigned to variable to s and another to j.

s = PartyAnimal("Sally")
s.party()

j = FootballFan("Jim")
j.party()
j.touchdown()
