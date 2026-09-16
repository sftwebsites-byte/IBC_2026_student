# Week 3 Practical

## 5.1 Markdown Homework

I converted my Week 1 practical answers into Markdown format and saved them as `Ghani_P1.txt`.

I used these commands to synchronize the file with my GitHub repository:

```bash
git add Practicals/W3/Ghani_P1.txt
git commit -m "Add Week 1 practical in Markdown format"
git push
```

## 5.2 Semicolon-Delimited to Comma-Delimited

I created a Bash script named `semicolon_csv_converter.sh`. It accepts a semicolon-delimited file as an argument and creates a comma-delimited file with a different name.

### Script

```bash
#!/bin/bash

input_file="$1"
output_file="${input_file%.*}_converted.csv"

tr ';' ',' < "$input_file" > "$output_file"

echo "Converted file saved as $output_file"
```

I made the script executable:

```bash
chmod +x Practicals/W3/semicolon_csv_converter.sh
```

I created a test file:

```bash
printf 'gene;count;species\nBRCA1;10;human\nTP53;8;mouse\n' > Practicals/W3/file_to_convert.csv
```

I ran the script:

```bash
bash Practicals/W3/semicolon_csv_converter.sh Practicals/W3/file_to_convert.csv
```

The converted file contained:

```text
gene,count,species
BRCA1,10,human
TP53,8,mouse
```
