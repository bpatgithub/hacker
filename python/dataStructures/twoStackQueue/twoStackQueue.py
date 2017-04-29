class MyQueue(object):
    def __init__(self):
        self.first = []  # first queue is used for append.
        self.second = [] # second queue is used for pop.

    def peek(self):
        self.prepSecond()
        return self.second[-1]

    def pop(self):
        self.prepSecond()
        return self.second.pop()

    def put(self, value):
        self.first.append(value)

    def prepSecond(self):
        if not self.second:  # if second is empty, fill it up from first.
            for item in range(len(self.first)):
                self.second.append(self.first.pop())

queue = MyQueue()
t = int(raw_input())
for line in xrange(t):
    values = map(int, raw_input().split())

    if values[0] == 1:
        queue.put(values[1])
    elif values[0] == 2:
        queue.pop()
    else:
        print(queue.peek())

'''
Notes:
A queue is an abstract data type that maintains the order in which elements were added to it, allowing the oldest elements to be removed from the front and new elements to be added to the rear. This is called a First-In-First-Out (FIFO) data structure because the first element added to the queue (i.e., the one that has been waiting the longest) is always the first one to be removed.

A basic queue has the following operations:

Enqueue: add a new element to the end of the queue.
Dequeue: remove the element from the front of the queue and return it.
In this challenge, you must first implement a queue using two stacks. Then process  queries, where each query is one of the following  types:

1 x: Enqueue element  into the end of the queue.
2: Dequeue the element at the front of the queue.
3: Print the element at the front of the queue.
Input Format

The first line contains a single integer, , denoting the number of queries.
Each line  of the  subsequent lines contains a single query in the form described in the problem statement above. All three queries start with an integer denoting the query , but only query  is followed by an additional space-separated value, , denoting the value to be enqueued.

Constraints

It is guaranteed that a valid answer always exists for each query of type .
Output Format

For each query of type , print the value of the element at the front of the queue on a new line.

Sample Input

10
1 42
2
1 14
3
1 28
3
1 60
1 78
2
2
Sample Output

14
14
Explanation

We perform the following sequence of actions:

Enqueue ; .
Dequeue the value at the head of the queue, ; .
Enqueue ; .
Print the value at the head of the queue, ; .
Enqueue ; .
Print the value at the head of the queue, ; .
Enqueue ; .
Enqueue ; .
Dequeue the value at the head of the queue, ; .
Dequeue the value at the head of the queue, ; .
'''
