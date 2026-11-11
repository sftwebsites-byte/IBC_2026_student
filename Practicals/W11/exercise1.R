# I reproduce the numeric pch symbols without expand.grid().
symbols <- 0:25
# I repeat column positions and row positions to arrange six columns.
x <- rep(1:6, each = 5)[seq_along(symbols)]
y <- rep(5:1, times = 6)[seq_along(symbols)]
stopifnot(length(x) == 26, length(y) == 26)
draw_symbols <- function() {
  par(mar = c(1, 1, 3, 1))
  plot(NA, xlim = c(0.5, 6.5), ylim = c(0.4, 5.5),
       axes = FALSE, xlab = "", ylab = "", main = "R plotting symbols (pch)")
  points(x, y, pch = symbols, cex = 2, col = "black", bg = "grey75")
  text(x, y - 0.32, labels = symbols, cex = 1)
}
png("pch_symbols.png", width = 1200, height = 900, res = 150)
draw_symbols()
dev.off()
pdf("pch_symbols.pdf", width = 8, height = 6)
draw_symbols()
dev.off()
