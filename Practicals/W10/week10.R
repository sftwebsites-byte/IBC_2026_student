# Week 10: Simulation and randomization

# Store the locations of the course data and my submission folder.
data_dir <- path.expand("~/IntroBiolComp-2026/R/DataFiles")
out_dir <- path.expand("~/IBC_2026_student/Practicals/W10")

# Check that the course data folder exists.
stopifnot(dir.exists(data_dir))

# Make my Week 10 folder the working directory.
setwd(out_dir)

# Use a seed so running the script again produces the same simulations.
set.seed(2214)

# PRACTICE EXERCISE 1: THREE TOADS
# Under the null hypothesis, either hand has a probability of 0.5.

test_toad <- function(right_used, trials, n_sim = 100000) {
  
  # Simulate the number of right-hand uses in many experiments.
  simulated_right <- rbinom(n_sim, size = trials, prob = 0.5)
  
  # Measure how far the observed result is from an equal split.
  observed_distance <- abs(right_used - trials / 2)
  
  # Count simulated results equally far or farther from an equal split.
  p_value <- mean(
    abs(simulated_right - trials / 2) >= observed_distance
  )
  
  # Classify the toad using a significance level of 0.05.
  handedness <- "No significant handedness"
  
  if (p_value < 0.05) {
    if (right_used > trials / 2) {
      handedness <- "Right-handed"
    } else {
      handedness <- "Left-handed"
    }
  }
  
  # Return the observations, simulated p-value, and conclusion.
  data.frame(
    Right_used = right_used,
    Trials = trials,
    P_value = p_value,
    Conclusion = handedness
  )
}

# Test the three toads described in the exercise.
practice_toads <- rbind(
  test_toad(2, 16),
  test_toad(15, 16),
  test_toad(13, 18)
)

# Display and save the results.
print(practice_toads)

write.csv(
  practice_toads,
  "practice_toad_results.csv",
  row.names = FALSE
)

# Inspect the remaining datasets so I can use their exact column names.
file_names <- c(
  "Pseudoscorpion_mating.tsv",
  "Toad_Handedness.tsv",
  "Jiang2013_data.csv"
)

for (file_name in file_names) {
  cat("\n---", file_name, "---\n")
  
  file_path <- file.path(data_dir, file_name)
  
  if (!file.exists(file_path)) {
    cat("File not found:", file_path, "\n")
    next
  }
  
  if (grepl("\\.tsv$", file_name)) {
    dat <- read.delim(file_path)
  } else {
    dat <- read.csv(file_path)
  }
  
  print(names(dat))
  print(head(dat))
}

# PRACTICE EXERCISE 2: PSEUDOSCORPION MATING

# Load the tab-separated data.
scorp <- read.delim(
  file.path(data_dir, "Pseudoscorpion_mating.tsv")
)

# Display the treatment names and their mean successful brood counts.
print(unique(scorp$Treatment))
print(tapply(scorp$Successful_broods, scorp$Treatment, mean))

# Identify the single-male and different-male treatment labels.
# Stop with a clear message if the labels are different than expected.
treatments <- unique(as.character(scorp$Treatment))
single_label <- treatments[
  tolower(treatments) %in% c("single", "sm")
]
different_label <- setdiff(treatments, single_label)

stopifnot(
  length(single_label) == 1,
  length(different_label) == 1
)

# Calculate the difference: different males minus a single male.
brood_difference <- function(broods) {
  mean(broods[scorp$Treatment == different_label]) -
    mean(broods[scorp$Treatment == single_label])
}

observed_difference <- brood_difference(scorp$Successful_broods)

# This function shuffles the response variable without replacement.
randomize_broods <- function(x) {
  sample(x, size = length(x), replace = FALSE)
}

# Repeat the randomization 10,000 times and store each mean difference.
set.seed(2215)
n_perm <- 10000

random_differences <- replicate(
  n_perm,
  brood_difference(randomize_broods(scorp$Successful_broods))
)

# Count differences at least as large in absolute magnitude.
extreme_count <- sum(
  abs(random_differences) >= abs(observed_difference)
)

# Calculate the two-sided p-value requested in the exercise.
scorp_p <- extreme_count / n_perm

scorp_results <- data.frame(
  Different_male_treatment = different_label,
  Single_male_treatment = single_label,
  Observed_difference = observed_difference,
  Extreme_randomizations = extreme_count,
  P_value = scorp_p
)

print(scorp_results)
write.csv(scorp_results, "scorpion_results.csv", row.names = FALSE)


# FINAL PROBLEM 1: TOAD HANDEDNESS

toads <- read.delim(
  file.path(data_dir, "Toad_Handedness.tsv")
)

# Apply our simulation function to every toad.
set.seed(2216)

toad_tests <- do.call(
  rbind,
  lapply(seq_len(nrow(toads)), function(i) {
    test_toad(toads$N_rights[i], toads$N_trials[i])
  })
)

toad_results <- cbind(
  toads,
  toad_tests[, c("P_value", "Conclusion")]
)

print(toad_results)
print(table(toad_results$Conclusion))

write.csv(
  toad_results,
  "toad_results.csv",
  row.names = FALSE
)

# Question 2: among toads showing significant handedness,
# test whether right and left handedness are equally likely.
n_right <- sum(toad_results$Conclusion == "Right-handed")
n_left <- sum(toad_results$Conclusion == "Left-handed")
n_handed <- n_right + n_left

stopifnot(n_handed > 0)

set.seed(2217)
simulated_right <- rbinom(100000, size = n_handed, prob = 0.5)

population_p <- mean(
  abs(simulated_right - n_handed / 2) >=
    abs(n_right - n_handed / 2)
)

population_results <- data.frame(
  Right_handed = n_right,
  Left_handed = n_left,
  P_value = population_p
)

print(population_results)
write.csv(
  population_results,
  "toad_population_results.csv",
  row.names = FALSE
)

# Question 3: compare the proportion right-handed in males and females.
# Include all toads; those not classified right-handed receive FALSE.
is_right <- toad_results$Conclusion == "Right-handed"
sex <- as.character(toad_results$Sex)

stopifnot(all(c("M", "F") %in% sex))

sex_difference <- function(right_status) {
  mean(right_status[sex == "M"]) -
    mean(right_status[sex == "F"])
}

observed_sex_difference <- sex_difference(is_right)

# Shuffle right-handed status while keeping sex group sizes fixed.
set.seed(2218)

random_sex_differences <- replicate(
  10000,
  sex_difference(sample(is_right, replace = FALSE))
)

sex_p <- mean(
  abs(random_sex_differences) >= abs(observed_sex_difference)
)

sex_results <- data.frame(
  Male_right_proportion = mean(is_right[sex == "M"]),
  Female_right_proportion = mean(is_right[sex == "F"]),
  Male_minus_female = observed_sex_difference,
  P_value = sex_p
)

print(sex_results)
write.csv(sex_results, "toad_sex_results.csv", row.names = FALSE)


# FINAL PROBLEM 2: ASSORTATIVE MATING

# This file is tab-separated despite the .csv extension.
jiang <- read.delim(
  file.path(data_dir, "Jiang2013_data.csv")
)

# Remove surrounding spaces and ensure r is numeric.
jiang$Taxon <- trimws(as.character(jiang$Taxon))
jiang$r <- as.numeric(as.character(jiang$r))

# Keep rows with a taxon and a usable correlation value.
jiang <- jiang[
  !is.na(jiang$r) & !is.na(jiang$Taxon) & jiang$Taxon != "",
]

# Question 1: return the mean r for the requested taxon.
mean_r <- function(desired_taxon) {
  values <- jiang$r[jiang$Taxon == desired_taxon]
  
  if (length(values) == 0) {
    stop("Taxon not found: ", desired_taxon)
  }
  
  mean(values)
}

print(mean_r("Fish"))

# Questions 2 and 3: compare each taxon's observed mean with
# 50,000 random samples from the complete dataset.
test_taxon <- function(desired_taxon, n_random = 50000) {
  values <- jiang$r[jiang$Taxon == desired_taxon]
  observed_mean <- mean_r(desired_taxon)
  sample_size <- length(values)
  
  # Sample without replacement within each random sample.
  random_means <- replicate(
    n_random,
    mean(sample(jiang$r, size = sample_size, replace = FALSE))
  )
  
  # Use an upper-tail test: is the observed mean especially high?
  p_value <- mean(random_means >= observed_mean)
  
  data.frame(
    Taxon = desired_taxon,
    N = sample_size,
    Mean_r = observed_mean,
    P_value = p_value
  )
}

set.seed(2219)

taxon_results <- do.call(
  rbind,
  lapply(sort(unique(jiang$Taxon)), test_taxon)
)

print(taxon_results)
write.csv(taxon_results, "taxon_results.csv", row.names = FALSE)

# Save the completed script into the submission folder.
# Your current script was saved in your home folder.
script_path <- path.expand("~/week10.R")
submission_script <- file.path(out_dir, "week10.R")

if (file.exists(script_path) &&
    normalizePath(script_path) !=
    normalizePath(submission_script, mustWork = FALSE)) {
  file.copy(script_path, submission_script, overwrite = TRUE)
}

cat("\nResults saved in:", out_dir, "\n")

