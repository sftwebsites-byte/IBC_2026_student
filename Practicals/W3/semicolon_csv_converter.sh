#!/bin/bash

input_file="$1"
output_file="${input_file%.*}_converted.csv"

tr ';' ',' < "$input_file" > "$output_file"

echo "Converted file saved as $output_file"
