# Week 6: Writing Good Code

## Exercise 1

I created a function that takes a name and a favorite activity and prints both.

## Exercise 2

1. I found that `foo1` returns the square root of a number. Its default input is 7.
2. I found that `foo2` returns the larger of two numbers. With its default inputs, 3 and 5, it returns 5.
3. I found that `foo3` returns the prime factors of a whole number greater than 1. For 1729, it returns [7, 13, 19]. Multiplying these numbers gives 1729.

## Debugging the Function

I used the debugger to check the position and codon as the function ran.
The first pair was (0, 'AUG'). The next pair was (4, 'AAU').

I found that the function moved forward four bases instead of three.
This skipped a base and produced the wrong amino acids.

I changed `i = i + 4` to `i = i + 3`.
I also changed `<` to `<=` so the function includes a final complete codon.

## My Line-by-Line Explanation of the Original Code

| Code | My explanation |
| --- | --- |
| `import pickle` | I load the module used to read saved Python objects. |
| `# load dictionary with genetic code from pickle file` | I read this as a comment explaining the next step. Comments do not run. |
| `genetic_code = pickle.load(open("../data/genetic_code.pickle", "rb"))` | I open the saved dictionary in binary read mode and load it into `genetic_code`. In my notebook, I use the file's actual location in the Python folder. |
| `# test case: desired amino acid sequence` | I read this as a comment introducing the test. |
| `# MEFSL[stop]` | I identify MEFSL as the expected protein, followed by a stop signal. |
| `test_mRNA = "AUGGAAUUCUCGCUCUGAAGGUAA"` | I store the RNA sequence used to test the function. |
| `def get_amino_acids(mRNA):` | I define a function that accepts an RNA sequence. |
| `i = 0` | I start at position zero, which is the first base. |
| `aa_sequence = []` | I create an empty list to hold amino acids. |
| `while (i + 3) < len(mRNA):` | I repeat the loop while the next triplet's end position is less than the sequence length. This condition skips a complete codon ending exactly at the end of the sequence. |
| `codon = mRNA[i:(i + 3)]` | I select three bases starting at position `i`. |
| `aa = genetic_code[codon]` | I look up the amino acid corresponding to that codon. |
| `if aa == "Stop":` | I check whether the codon is a stop signal. |
| `break` | I end the loop when a stop signal is found. |
| `else:` | I follow this branch when the codon is not a stop signal. |
| `aa_sequence.append(aa)` | I add the amino acid to the list. |
| `# advance to the next codon` | I read this as a comment describing the intended next step. |
| `i = i + 4` | I move forward four bases. I identified this as the main bug because a codon contains three bases. |
| `return "".join(aa_sequence)` | I join the amino acids into one string and return it. |
| `print(get_amino_acids(test_mRNA))` | I call the function with the test sequence and print its result. |
| `# problem: the program returns MNLLEV instead of the expected MEFSL!` | I read this as a comment describing the incorrect output. |

## Gobbler Proteins

I read 15 records from the supplied coding FASTA file.
I converted T to U and translated the available DNA sequences using my corrected function.
I preserved each header and changed its ending from gbkey=CDS to gbskey=AA.

I found that the final record, XP_085091111.1, had a header but no DNA sequence.
Therefore, I could translate only 14 proteins.
I preserved the final header with an empty sequence in my output rather than inventing missing data.

I saved the results in Turkey_proteins_15.fasta.
