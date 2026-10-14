import re


def GC_content(seq):
    seq = re.sub(r"\s+", "", seq).upper()

    if not seq:
        raise ValueError("The sequence cannot be empty.")

    if re.fullmatch(r"[ACGT]+", seq) is None:
        raise ValueError("The sequence must contain only A, C, G, and T.")

    gc_count = len(re.findall(r"[GC]", seq))
    return gc_count / len(seq)


if __name__ == "__main__":
    sequence = "AAGTCGTGAGCA"
    result = GC_content(sequence)

    print("Sequence:", sequence)
    print("GC proportion:", result)
    print(f"GC percentage: {result:.2%}")
