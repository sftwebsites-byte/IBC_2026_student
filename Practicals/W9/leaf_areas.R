
# I use the supplied function to measure each plant image.
library(EBImage)
source(file.path(out_dir, "getArea.R"))

image_files <- list.files(
    leaf_dir,
    pattern = "\\.JPG$",
    full.names = TRUE,
    ignore.case = TRUE
)

if (length(image_files) == 0) {
    stop("No plant images were found.")
}

results <- data.frame(
    File = character(),
    Plant = character(),
    Timepoint = character(),
    LeafArea_pixels = numeric()
)

for (f in image_files) {
    filename <- basename(f)
    message("Processing ", filename)

    timepoint <- tolower(sub("_.*$", "", filename))
    plant <- sub("^[^_]+_", "", filename)
    plant <- sub("\\.[^.]+$", "", plant)

    area <- as.numeric(getArea(f))

    if (length(area) != 1 || !is.finite(area)) {
        stop(paste("Invalid area measurement for", filename))
    }

    results <- rbind(
        results,
        data.frame(
            File = filename,
            Plant = plant,
            Timepoint = timepoint,
            LeafArea_pixels = area
        )
    )
}

# I check that each plant has one image at each time point.
if (!all(results$Timepoint %in% c("t1", "t2"))) {
    stop("An image has an unexpected time point.")
}

if (anyDuplicated(results[c("Plant", "Timepoint")])) {
    stop("Duplicate plant/time-point combinations were found.")
}

t1 <- results[
    results$Timepoint == "t1",
    c("Plant", "LeafArea_pixels")
]
t2 <- results[
    results$Timepoint == "t2",
    c("Plant", "LeafArea_pixels")
]

names(t1)[2] <- "Area_t1_pixels"
names(t2)[2] <- "Area_t2_pixels"

growth <- merge(t1, t2, by = "Plant", all = TRUE)

if (anyNA(growth)) {
    stop("At least one plant is missing a time point.")
}

# I calculate growth as area at t2 minus area at t1.
growth$Growth_pixels <- (
    growth$Area_t2_pixels - growth$Area_t1_pixels
)

average_growth <- mean(growth$Growth_pixels)

# I add each plant growth measurement to the image-level results.
results$Growth_pixels <- growth$Growth_pixels[
    match(results$Plant, growth$Plant)
]

write.csv(
    results,
    file.path(out_dir, "LeafAreaResults.csv"),
    row.names = FALSE
)

write.csv(
    growth,
    file.path(out_dir, "PlantGrowth.csv"),
    row.names = FALSE
)

