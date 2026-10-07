import pickle
from pathlib import Path

repo = Path(__file__).resolve().parents[2]

with open(repo / "Python/genetic_code.pickle", "rb") as file:
    genetic_code = pickle.load(file)


def get_amino_acids(mRNA):
    amino_acids = []

    for i in range(0, len(mRNA) - 2, 3):
        codon = mRNA[i:i + 3]
        aa = genetic_code[codon]
        if aa == "Stop":
            break
        amino_acids.append(aa)

    return "".join(amino_acids)


def read_fasta(path):
    records = []
    header = None
    parts = []

    with open(path) as file:
        for line in file:
            line = line.strip()
            if not line:
                continue
            if line.startswith(">"):
                if header is not None:
                    records.append((header, "".join(parts)))
                header = line
                parts = []
            else:
                parts.append(line)

    if header is not None:
        records.append((header, "".join(parts)))

    return records


if __name__ == "__main__":
    assert get_amino_acids("AUGGAAUUCUCGCUCUGAAGGUAA") == "MEFSL"
    assert get_amino_acids("AUG") == "M"

    input_file = repo / "Python/DataFiles/Turkey_transcripts_15_coding.fasta"
    output_file = Path(__file__).resolve().parent / "Turkey_proteins_15.fasta"
    records = read_fasta(input_file)
    assert len(records) == 15

    translated = 0
    with open(output_file, "w") as file:
        for header, dna in records:
            assert header.endswith("gbkey=CDS")
            new_header = header[:-len("gbkey=CDS")] + "gbskey=AA"
            protein = get_amino_acids(dna.upper().replace("T", "U"))

            file.write(new_header + "\n")
            if not dna:
                print("Missing DNA:", header.split()[0])
                file.write("\n")
                continue

            assert protein, "Nonempty DNA produced an empty protein"
            translated += 1
            for start in range(0, len(protein), 60):
                file.write(protein[start:start + 60] + "\n")

    print("Records saved:", len(records))
    print("Proteins translated:", translated)
    print("Saved:", output_file)
