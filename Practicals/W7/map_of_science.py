import csv
import re
from collections import Counter
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

folder = Path(__file__).resolve().parent

# Read ZIP codes and their coordinates.
coordinates = {}

with (folder / "zipcodes_coordinates.txt").open(
    encoding="utf-8-sig", newline=""
) as handle:
    reader = csv.DictReader(handle, skipinitialspace=True)

    for row in reader:
        zip_value = row["ZIP"].strip().zfill(5)
        coordinates[zip_value] = (
            float(row["LNG"]),
            float(row["LAT"]),
        )

# Extract five-digit ZIP codes, including ZIP+4 codes.
text = (folder / "pubmed_results.txt").read_text(
    encoding="utf-8", errors="replace"
)

candidates = re.findall(
    r"(?<!\w)([0-9]{5})(?:-[0-9]{4})?(?![\w-])",
    text,
)

# Keep candidates present in the coordinate table.
counts = Counter(
    value for value in candidates if value in coordinates
)

if not counts:
    raise ValueError("No ZIP codes matched the coordinate table.")

# Create the four lists required by the assignment.
zip_code = sorted(counts)
zip_long = [coordinates[value][0] for value in zip_code]
zip_lat = [coordinates[value][1] for value in zip_code]
zip_count = [counts[value] for value in zip_code]

# Save the calculated results.
with (folder / "zip_summary.csv").open("w", newline="") as handle:
    writer = csv.writer(handle)
    writer.writerow(["zip_code", "zip_long", "zip_lat", "zip_count"])
    writer.writerows(zip(zip_code, zip_long, zip_lat, zip_count))

# Plot the continental United States.
fig, ax = plt.subplots(figsize=(15, 9))

points = ax.scatter(
    zip_long,
    zip_lat,
    s=zip_count,
    c=zip_count,
    cmap="viridis",
)

fig.colorbar(points, ax=ax, label="ZIP-code occurrences")
ax.set_xlim(-125, -65)
ax.set_ylim(23, 50)
ax.set_xlabel("Longitude")
ax.set_ylabel("Latitude")
ax.set_title("Map of Science: Science Publications in 2015")

cities = [
    ("Los Angeles", (-118.25, 34.05), (-108.25, 34.05)),
    ("Palo Alto", (-122.1381, 37.4292), (-112.1381, 37.4292)),
    ("Cambridge", (-71.1106, 42.3736), (-73.1106, 48.3736)),
    ("Chicago", (-87.6847, 41.8369), (-87.6847, 46.8369)),
    ("Seattle", (-122.33, 47.61), (-116.33, 47.61)),
    ("Miami", (-80.21, 25.7753), (-80.21, 30.7753)),
]

for name, location, label_location in cities:
    ax.annotate(
        name,
        xy=location,
        xytext=label_location,
        arrowprops={"arrowstyle": "->"},
    )

fig.tight_layout()
fig.savefig(folder / "map_of_science.png", dpi=200)
plt.close(fig)

print("Unique ZIP codes:", len(zip_code))
print("Total ZIP-code occurrences:", sum(zip_count))
print("Created zip_summary.csv")
print("Created map_of_science.png")
