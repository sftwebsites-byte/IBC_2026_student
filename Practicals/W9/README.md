# Week 9 Practical: R Scripting

## File Processing

I used list.files() to find the text files in R/DataFiles/Saavedra2013. I used a for loop to read each file with read.table() and convert it into a matrix.

I calculated the number of rows with nrow() and the number of columns with ncol(). I calculated the proportion of ones by dividing the number of entries equal to 1 by the total number of entries. I used the same method for zeros.

I processed 59 matrices and saved the results in MatrixStats.tsv.

My output contains File, Nrow, Ncol, p_1, and p_0.

## Leaf Areas

I used the EBImage package and the supplied getArea() function to measure projected leaf area in pixels. I used a for loop to process every JPG image and stored the image names, plant identifiers, time points, and areas in the data frame results.

I processed 44 images representing 22 plants.

I matched the two time points by plant identifier. For each plant, I calculated growth as its area at t2 minus its area at t1. A positive value indicates an increase in projected leaf area, and a negative value indicates a decrease.

The mean change in projected leaf area was 7097.45 pixels per plant.

I calculated this average from one change value per plant. I added the growth values to results and saved the data in LeafAreaResults.csv. I also saved a table with one row per plant in PlantGrowth.csv.

These measurements represent projected area in pixels. Interpreting them as physical growth assumes that the photos have comparable scales and imaging conditions.

## Files

- matrix_stats.R: my matrix-processing script.
- MatrixStats.tsv: the matrix statistics.
- leaf_areas.R: my leaf-area and growth script.
- getArea.R: the original function supplied with the course.
- LeafAreaResults.csv: image measurements with plant growth.
- PlantGrowth.csv: paired areas and growth for each plant.
- run_W9.R: a script for rerunning both analyses.
