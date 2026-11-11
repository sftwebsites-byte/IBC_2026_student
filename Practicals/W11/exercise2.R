# I read the freely available penguin data supplied with this folder.
penguins <- read.csv("penguins.csv", na.strings = c("", "NA"))
# I retain every penguin with both measurements needed for this figure.
penguins <- penguins[complete.cases(penguins[c("flipper_length_mm", "body_mass_g")]), ]
data(iris)
groups <- c("Adelie", "Chinstrap", "Gentoo")
colors <- c("#E69F00", "#56B4E9", "#009E73")
shapes <- c(16, 17, 15)
stopifnot(nrow(penguins) == 342, nrow(iris) == 150)
draw_panel <- function(x, y, group, levels, cols, pchs, xlab, ylab, panel) {
  plot(x, y, type = "n", xlab = xlab, ylab = ylab, las = 1)
  grid(col = "grey90")
  for (i in seq_along(levels)) {
    keep <- group == levels[i]
    points(x[keep], y[keep], col = adjustcolor(cols[i], alpha.f = 0.75),
           pch = pchs[i], cex = 0.8)
    # I fit each species separately and restrict its line to its observed x range.
    fit <- lm(y[keep] ~ x[keep])
    xx <- range(x[keep])
    lines(xx, coef(fit)[1] + coef(fit)[2] * xx, col = cols[i], lwd = 2)
  }
  legend("topleft", legend = levels, col = cols, pch = pchs, bty = "n", cex = 0.8)
  mtext(panel, side = 3, adj = 0, line = 0.5, font = 2)
}
draw_figure <- function() {
  par(mfrow = c(1, 2), mar = c(4.5, 4.5, 2, 1), mgp = c(2.8, 0.8, 0))
  draw_panel(penguins$flipper_length_mm, penguins$body_mass_g,
             penguins$species, groups, colors, shapes,
             "Flipper length (mm)", "Body mass (g)", "A")
  draw_panel(iris$Petal.Length, iris$Petal.Width,
             as.character(iris$Species), levels(iris$Species),
             c("grey75", "grey50", "black"), shapes,
             "Petal length (cm)", "Petal width (cm)", "B")
}
png("recreated_figure.png", width = 1800, height = 1050, res = 180)
draw_figure()
dev.off()
pdf("recreated_figure.pdf", width = 10, height = 5.83)
draw_figure()
dev.off()
