
# *** WIP (work in progress) ***
# get input.
arr_i=[1,3,6,7,462,4,85,2,8,943,3,5,32,8,421,774,3,6,4235,3,6,4,35]

# recursive algorithm.
# 1.  Get all values lower than pivot.
# 2.  Get Pivot - which is mid-of array.
# 3.  Get all values higher than pivot.


def quicksort(ai):
    # if array input is < 1, return same value.
    if (len(ai) < 2):
        return ai

    # select a pivot.
    midpt = int(len(ai)/2)
    p = ai[midpt]

    for v in ai:
        if (v <= p):
            lower.append(v)
        else:
            upper.append(v)

    print(lower)
    print(upper)

    retlist=lower.extend(upper)
    return (quicksort(retlist)

lower=[]
upper=[]
#print(quicksort(arr_i))
