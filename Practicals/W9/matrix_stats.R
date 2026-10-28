
# I load each ecological interaction matrix and summarize its entries.
matrix_files <- list.files(
    file.path(data_dir, "Saavedra2013"),
    pattern = "\\.txt$",
    full.names = TRUE,
    ignore.case = TRUE
)

if (length(matrix_files) == 0) {
    stop("No matrix files were found.")
}

matrix_stats <- data.frame(
    File = character(),
    Nrow = integer(),
    Ncol = integer(),
    p_1 = numeric(),
    p_0 = numeric()
)

for (f in matrix_files) {
    mat <- as.matrix(read.table(f, header = FALSE))

    if (anyNA(mat) || !all(mat %in% c(0, 1))) {
        stop(paste("Nonbinary or missing entries in", basename(f)))
    }

    matrix_stats <- rbind(
        matrix_stats,
        data.frame(
            File = basename(f),
            Nrow = nrow(mat),
            Ncol = ncol(mat),
            p_1 = sum(mat == 1) / length(mat),
            p_0 = sum(mat == 0) / length(mat)
        )
    )
}

write.table(
    matrix_stats,
    file.path(out_dir, "MatrixStats.tsv"),
    sep = "\t",
    row.names = FALSE,
    quote = FALSE
)

