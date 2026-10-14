import re

patterns = {
    "Protein": r"[A-Za-z]{3}[0-9]{5}",
    "Whole genome": r"[A-Za-z]{4}[0-9]{2}[0-9]{6,8}",
    "Nucleotide": r"(?:[A-Za-z][0-9]{5}|[A-Za-z]{2}[0-9]{6})",
}

examples = [
    "ABC12345",
    "ABCD01000001",
    "A12345",
    "AB123456",
    "invalid123",
]

for accession in examples:
    category = "No matching format"

    for name, pattern in patterns.items():
        if re.fullmatch(pattern, accession):
            category = name
            break

    print(f"{accession}: {category}")
