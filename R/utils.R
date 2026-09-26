
.assert_numeric <- function(x, name, allow_empty = FALSE) {
  if (!is.numeric(x)) {
    stop(sprintf("`%s` must be numeric.", name), call. = FALSE)
  }
  if (!allow_empty && length(x) == 0L) {
    stop(sprintf("`%s` must not be empty.", name), call. = FALSE)
  }
  invisible(TRUE)
}

.assert_same_length <- function(x, y, x_name, y_name) {
  if (length(x) != length(y)) {
    stop(sprintf("`%s` and `%s` must have the same length.", x_name, y_name),
         call. = FALSE)
  }
  invisible(TRUE)
}

.clean_finite <- function(x, na.rm = TRUE) {
  if (na.rm) {
    x <- x[is.finite(x)]
  } else if (any(!is.finite(x))) {
    stop("Input contains missing or non-finite values.", call. = FALSE)
  }
  x
}

.clip <- function(x, lower = -Inf, upper = Inf) {
  pmin(pmax(x, lower), upper)
}

.safe_scale <- function(x, center = NULL, scale = NULL, eps = 1e-8) {
  if (is.null(center)) center <- mean(x)
  if (is.null(scale)) scale <- stats::sd(x)
  if (!is.finite(scale) || scale < eps) scale <- 1
  list(z = (x - center) / scale, center = center, scale = scale)
}
