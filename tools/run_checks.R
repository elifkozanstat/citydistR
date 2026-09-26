# Run this script from the directory that contains the citydistR folder.
# It installs testthat if necessary, runs tests, builds the package, and checks it.

if (!requireNamespace("testthat", quietly = TRUE)) {
  install.packages("testthat")
}

cat("\n1) Installing source package...\n")
system("R CMD INSTALL citydistR", intern = FALSE)

cat("\n2) Running package tests...\n")
testthat::test_dir("citydistR/tests/testthat", reporter = "summary")

cat("\n3) Building source archive...\n")
status_build <- system("R CMD build citydistR", intern = FALSE)

if (status_build != 0) {
  stop("R CMD build failed.")
}

archives <- list.files(pattern = "^citydistR_[0-9.]+\\.tar\\.gz$")
if (length(archives) == 0L) {
  stop("No built source archive found.")
}
archive <- archives[which.max(file.info(archives)$mtime)]

cat("\n4) Running R CMD check --as-cran on:", archive, "\n")
status_check <- system(paste("R CMD check --as-cran", shQuote(archive)),
                       intern = FALSE)

if (status_check != 0) {
  stop("R CMD check reported problems. Inspect the *.Rcheck directory.")
}

cat("\nAll requested checks completed successfully.\n")
