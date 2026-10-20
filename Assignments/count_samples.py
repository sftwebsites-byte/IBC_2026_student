import sys

filename = sys.argv[1]
individual = sys.argv[2]
count = 0

with open(filename) as file:
    next(file)
    for line in file:
        columns = line.split()
        if columns and columns[0] == individual:
            count += 1

print(count)
