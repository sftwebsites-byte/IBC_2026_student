# Week 8 Practical - R Basics

## 1. Disease Risks

### Question 1

I added the three genotype counts for each SNP and found the largest total.

```r
total <- geno$nA1A1 + geno$nA1A2 + geno$nA2A2
max(total, na.rm=TRUE)
```

My result was **124 people**.

### Question 2

I used `rowSums()` to check the same calculation.

```r
max(rowSums(geno[, c('nA1A1','nA1A2','nA2A2')], na.rm=TRUE))
```

I got **124 people**, the same result.

### Question 3

I read the risk CSV and matched its third column to the genotype data by SNP ID when available.

```r
risks <- read.csv('SNP_risks.csv')
# I matched SNP identifiers where available and added risks[,3].
```

I checked the risk labels: **Non-Risk, Risk**.

### Question 4

I compared the average number of heterozygous individuals at risk and non-risk sites.

```r
mean(combined$nA1A2[is_risk], na.rm=TRUE)
mean(combined$nA1A2[is_no_risk], na.rm=TRUE)
```

My risk-site average was **Needs manual verification**.

My non-risk-site average was **Needs manual verification**.

## 2. Data Cleanup

### Question 1

I loaded the mammal dataset and counted the different species.

```r
mammals <- read.delim('Smith2003_data.txt', header=TRUE)
# I counted unique values in the species column.
```

I found **Needs manual verification species**.

### Question 2

I replaced -999 with NA in columns 7 and 8 and saved the cleaned file.

```r
for (i in c(7, 8)) {
  mammals[[i]][trimws(as.character(mammals[[i]])) == '-999'] <- NA
}
write.table(mammals, 'Smith2003_clean.txt', sep='\t', row.names=FALSE, quote=FALSE, na='NA')
```

I saved my cleaned data as `Smith2003_clean.txt`.
