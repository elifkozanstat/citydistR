
#' Compute detour factors
#'
#' Computes the ratio between network distance and Euclidean distance.
#'
#' @param network_distance Numeric vector of network or shortest-path distances.
#' @param euclidean_distance Numeric vector of Euclidean distances.
#' @param eps Small positive constant used only for numerical protection.
#' @param min_df Lower clipping bound for valid detour factors.
#' @param max_df Upper clipping bound for valid detour factors.
#' @param invalid Character string controlling non-positive Euclidean distances:
#'   `"na"` returns `NA`, while `"error"` stops.
#'
#' @return A numeric vector of detour factors.
#' @export
#'
#' @examples
#' detour_factor(c(12, 25), c(10, 20))
detour_factor <- function(network_distance, euclidean_distance,
                          eps = 1e-8, min_df = 0, max_df = Inf,
                          invalid = c("na", "error")) {
  invalid <- match.arg(invalid)
  .assert_numeric(network_distance, "network_distance")
  .assert_numeric(euclidean_distance, "euclidean_distance")
  .assert_same_length(network_distance, euclidean_distance,
                      "network_distance", "euclidean_distance")

  bad <- !is.finite(network_distance) | !is.finite(euclidean_distance) |
    euclidean_distance <= 0

  if (invalid == "error" && any(bad)) {
    stop("Distances must be finite and Euclidean distances must be positive.",
         call. = FALSE)
  }

  out <- rep(NA_real_, length(network_distance))
  ok <- !bad
  out[ok] <- network_distance[ok] / pmax(euclidean_distance[ok], eps)
  out[ok] <- .clip(out[ok], min_df, max_df)
  out
}

#' Topological Predictability Index
#'
#' Computes the Topological Predictability Index (TPI):
#' `TPI = 1 / (1 + CV)`, where `CV = sd(DF) / (mean(DF) + eps)`.
#'
#' @param detour Numeric vector of detour factors.
#' @param eps Small positive constant.
#' @param na.rm Logical; remove missing and non-finite values.
#'
#' @return A single numeric TPI value.
#' @export
#'
#' @examples
#' tpi(c(1.0, 1.1, 1.3, 1.8))
tpi <- function(detour, eps = 1e-8, na.rm = TRUE) {
  .assert_numeric(detour, "detour")
  x <- .clean_finite(detour, na.rm = na.rm)
  if (length(x) < 2L) return(NA_real_)
  mu <- mean(x)
  s <- stats::sd(x)
  cv <- s / (mu + eps)
  1 / (1 + cv)
}

#' Tail95 detour-heaviness index
#'
#' Computes `Q_0.95(DF) / median(DF)`.
#'
#' @param detour Numeric vector of detour factors.
#' @param prob Quantile probability; default is 0.95.
#' @param eps Small positive constant for numerical protection.
#' @param na.rm Logical; remove missing and non-finite values.
#'
#' @return A single numeric tail-heaviness value.
#' @export
#'
#' @examples
#' tail95(c(1.0, 1.1, 1.2, 1.4, 2.5))
tail95 <- function(detour, prob = 0.95, eps = 1e-8, na.rm = TRUE) {
  .assert_numeric(detour, "detour")
  x <- .clean_finite(detour, na.rm = na.rm)
  if (length(x) == 0L) return(NA_real_)
  med <- stats::median(x)
  q <- as.numeric(stats::quantile(x, probs = prob, names = FALSE,
                                  na.rm = na.rm, type = 7))
  q / pmax(abs(med), eps)
}

#' Summarize city-level detour structure
#'
#' Computes detour factors (if needed) and returns TPI, Tail95 and supporting
#' descriptive statistics.
#'
#' @param network_distance Optional numeric vector of network distances.
#' @param euclidean_distance Optional numeric vector of Euclidean distances.
#' @param detour Optional numeric vector of pre-computed detour factors.
#' @param eps Small positive constant.
#' @param na.rm Logical; remove missing and non-finite values.
#'
#' @return A one-row data frame with city-level structural diagnostics.
#' @export
#'
#' @examples
#' city_indices(detour = c(1.0, 1.1, 1.2, 1.4, 2.5))
city_indices <- function(network_distance = NULL, euclidean_distance = NULL,
                         detour = NULL, eps = 1e-8, na.rm = TRUE) {
  if (is.null(detour)) {
    if (is.null(network_distance) || is.null(euclidean_distance)) {
      stop("Provide either `detour` or both distance vectors.", call. = FALSE)
    }
    detour <- detour_factor(network_distance, euclidean_distance)
  }
  .assert_numeric(detour, "detour")
  x <- .clean_finite(detour, na.rm = na.rm)
  if (length(x) == 0L) {
    return(data.frame(
      n = 0L, mean_df = NA_real_, median_df = NA_real_, sd_df = NA_real_,
      TPI = NA_real_, Tail95 = NA_real_
    ))
  }
  data.frame(
    n = length(x),
    mean_df = mean(x),
    median_df = stats::median(x),
    sd_df = if (length(x) >= 2L) stats::sd(x) else NA_real_,
    TPI = tpi(x, eps = eps, na.rm = TRUE),
    Tail95 = tail95(x, eps = eps, na.rm = TRUE)
  )
}

#' Decide whether robust loss should be activated
#'
#' @param tail95_value Numeric Tail95 value.
#' @param threshold Activation threshold. The tested road-network configuration
#'   used 1.35; users may supply another value.
#'
#' @return Logical value.
#' @export
#'
#' @examples
#' robust_loss_active(1.42)
robust_loss_active <- function(tail95_value, threshold = 1.35) {
  .assert_numeric(tail95_value, "tail95_value")
  if (length(tail95_value) != 1L || !is.finite(tail95_value)) {
    stop("`tail95_value` must be one finite number.", call. = FALSE)
  }
  tail95_value >= threshold
}
