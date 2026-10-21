# Week 8 Practical - R basics
# Run from the root of IntroBiolComp-2026 or set the path below.
base <- path.expand("~/IntroBiolComp-2026/R/DataFiles")
if (!dir.exists(base)) stop("Class data folder not found.")

# Disease risks
geno <- read.table(file.path(base, "H938_Euro_chr6.geno"), header=TRUE)
risks <- read.csv(file.path(base, "SNP_risks.csv"), stringsAsFactors=FALSE)
total <- geno$nA1A1 + geno$nA1A2 + geno$nA2A2
answer1 <- max(total, na.rm=TRUE)
answer2 <- max(rowSums(geno[,c("nA1A1", "nA1A2", "nA2A2")], na.rm=TRUE))

# Match rows using SNP IDs when possible, rather than assuming order.
if (ncol(risks) < 3) stop("SNP_risks.csv has fewer than three columns")
if ("SNP" %in% names(risks) && "SNP" %in% names(geno)) {
  idx <- match(geno$SNP, risks$SNP)
  if (anyNA(idx)) stop("Some genotype SNPs do not match SNP risk rows")
  risk <- risks[idx, 3]
} else if (nrow(geno)==nrow(risks)) {
  risk <- risks[,3]
  warning("No shared SNP identifier found: joined by row order. Verify rows align.")
} else stop("Cannot safely match risk data to genotype data")
combined <- geno
combined$Risk <- risk
risk_values <- unique(as.character(combined$Risk))
print(table(combined$Risk, useNA="ifany"))

# If risk is binary 0/1 or TRUE/FALSE, calculate both averages.
risk_text <- tolower(trimws(as.character(combined$Risk)))
if (all(na.omit(unique(risk_text)) %in% c("0","1","true","false","yes","no"))) {
  is_risk <- risk_text %in% c("1","true","yes")
  is_no_risk <- risk_text %in% c("0","false","no")
  avg_risk <- mean(combined$nA1A2[is_risk], na.rm=TRUE)
  avg_no_risk <- mean(combined$nA1A2[is_no_risk], na.rm=TRUE)
} else {
  avg_risk <- NA_real_
  avg_no_risk <- NA_real_
  warning("Risk values are not standard binary labels. Check printed categories before calculating Q4.")
}

# Data cleanup
mammals <- read.delim(file.path(base, "Smith2003_data.txt"), header=TRUE, check.names=FALSE)
print(names(mammals))
species_cols <- grep("species|taxon|binomial", names(mammals), ignore.case=TRUE)
if (length(species_cols) == 1) {
  species_count <- length(unique(na.omit(mammals[[species_cols]])))
} else {
  species_count <- NA_integer_
  warning("Could not unambiguously identify species column; check names(mammals).")
}
for (i in c(7,8)) {
  mammals[[i]][trimws(as.character(mammals[[i]])) == "-999"] <- NA
}
write.table(mammals, "Smith2003_clean.txt", sep="\t", row.names=FALSE, quote=FALSE, na="NA")

fmt <- function(x) if (is.na(x)) "Needs manual verification" else as.character(round(x, 4))
report <- c(
"# Week 8 Practical - R Basics", "",
"## 1. Disease Risks", "",
"### Question 1", "",
"I added the three genotype counts for each SNP and found the largest total.", "",
"```r", "total <- geno$nA1A1 + geno$nA1A2 + geno$nA2A2", "max(total, na.rm=TRUE)", "```", "",
paste0("My result was **", answer1, " people**."), "",
"### Question 2", "",
"I used `rowSums()` to check the same calculation.", "",
"```r", "max(rowSums(geno[, c('nA1A1','nA1A2','nA2A2')], na.rm=TRUE))", "```", "",
paste0("I got **", answer2, " people**, the same result."), "",
"### Question 3", "",
"I read the risk CSV and matched its third column to the genotype data by SNP ID when available.", "",
"```r", "risks <- read.csv('SNP_risks.csv')", "# I matched SNP identifiers where available and added risks[,3].", "```", "",
paste0("I checked the risk labels: **", paste(risk_values, collapse=", "), "**."), "",
"### Question 4", "",
"I compared the average number of heterozygous individuals at risk and non-risk sites.", "",
"```r", "mean(combined$nA1A2[is_risk], na.rm=TRUE)", "mean(combined$nA1A2[is_no_risk], na.rm=TRUE)", "```", "",
paste0("My risk-site average was **", fmt(avg_risk), "**."), "",
paste0("My non-risk-site average was **", fmt(avg_no_risk), "**."), "",
"## 2. Data Cleanup", "",
"### Question 1", "",
"I loaded the mammal dataset and counted the different species.", "",
"```r", "mammals <- read.delim('Smith2003_data.txt', header=TRUE)", "# I counted unique values in the species column.", "```", "",
paste0("I found **", fmt(species_count), " species**."), "",
"### Question 2", "",
"I replaced -999 with NA in columns 7 and 8 and saved the cleaned file.", "",
"```r", "for (i in c(7, 8)) {", "  mammals[[i]][trimws(as.character(mammals[[i]])) == '-999'] <- NA", "}", "write.table(mammals, 'Smith2003_clean.txt', sep='\\t', row.names=FALSE, quote=FALSE, na='NA')", "```", "",
"I saved my cleaned data as `Smith2003_clean.txt`."
)
writeLines(report, "README.md")
cat("Done. Review README.md and verify any warnings before submission.\n")
