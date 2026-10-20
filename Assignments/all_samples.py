counts = {}

with open("Gesquiere2011_data.csv") as file:
    next(file)
    for line in file:
        columns = line.split()
        if columns:
            individual = int(columns[0])
            counts[individual] = counts.get(individual, 0) + 1

with open("Num_samples.csv", "w") as output:
    output.write("maleID,Num_samples\n")
    for individual in sorted(counts):
        output.write(f"{individual},{counts[individual]}\n")
