
#' City-adaptive validation weights
#'
#' Computes the tail-risk and ranking-consistency weights used in a modular
#' city-adaptive validation score.
#'
#' @param tail95_value Numeric Tail95 value.
#' @param tpi_value Numeric TPI value.
#' @param tail95_sat Saturation constant for normalized tail risk; must exceed 1.
#' @param lambda_max Maximum tail-risk weight.
#' @param gamma_max Maximum ranking-consistency weight.
#'
#' @return A named numeric vector containing `lambda`, `gamma`, and
#'   `normalized_tail`.
#' @export
#'
#' @examples
#' adaptive_weights(1.6, 0.78, tail95_sat = 2)
adaptive_weights <- function(tail95_value, tpi_value, tail95_sat = 2,
                             lambda_max = 1, gamma_max = 1) {
  .assert_numeric(tail95_value, "tail95_value")
  .assert_numeric(tpi_value, "tpi_value")
  vals <- c(tail95_value, tpi_value, tail95_sat, lambda_max, gamma_max)
  if (any(!is.finite(vals))) stop("All inputs must be finite.", call. = FALSE)
  if (tail95_sat <= 1) stop("`tail95_sat` must be greater than 1.", call. = FALSE)

  normalized_tail <- .clip((tail95_value - 1) / (tail95_sat - 1), 0, 1)
  lambda <- lambda_max * normalized_tail
  gamma <- gamma_max * max(0, 1 - tpi_value)
  c(lambda = lambda, gamma = gamma, normalized_tail = normalized_tail)
}

#' City-adaptive multi-criteria validation score
#'
#' Combines normalized MAE, normalized P95 absolute error, and Spearman rank
#' correlation. Lower values indicate better validation performance.
#'
#' @param true_distance Numeric vector of true distances.
#' @param pred_distance Numeric vector of predicted distances.
#' @param tail95_value Numeric Tail95 value computed from training data.
#' @param tpi_value Numeric TPI value computed from training data.
#' @param tail95_sat Saturation constant for tail weighting.
#' @param lambda_max Maximum tail-risk weight.
#' @param gamma_max Maximum ranking-consistency weight.
#' @param eps Small positive constant.
#'
#' @return A named numeric vector with the overall score and its components.
#' @export
#'
#' @examples
#' y <- c(10, 20, 30, 40, 50)
#' yh <- c(11, 18, 32, 39, 52)
#' adaptive_validation_score(y, yh, tail95_value = 1.5, tpi_value = 0.8)
adaptive_validation_score <- function(true_distance, pred_distance,
                                      tail95_value, tpi_value,
                                      tail95_sat = 2,
                                      lambda_max = 1, gamma_max = 1,
                                      eps = 1e-8) {
  .assert_numeric(true_distance, "true_distance")
  .assert_numeric(pred_distance, "pred_distance")
  .assert_same_length(true_distance, pred_distance,
                      "true_distance", "pred_distance")

  ok <- is.finite(true_distance) & is.finite(pred_distance)
  y <- true_distance[ok]
  yh <- pred_distance[ok]
  if (length(y) < 2L) stop("At least two valid observations are required.",
                           call. = FALSE)

  err <- abs(yh - y)
  mae <- mean(err)
  p95 <- as.numeric(stats::quantile(err, 0.95, names = FALSE, type = 7))
  rho <- suppressWarnings(stats::cor(y, yh, method = "spearman"))
  if (!is.finite(rho)) rho <- 0

  scale_d <- max(abs(stats::median(y)), eps)
  w <- adaptive_weights(tail95_value, tpi_value, tail95_sat,
                        lambda_max, gamma_max)

  score <- mae / scale_d + w[["lambda"]] * p95 / scale_d -
    w[["gamma"]] * rho

  c(
    score = unname(score),
    normalized_mae = mae / scale_d,
    normalized_p95 = p95 / scale_d,
    spearman = rho,
    lambda = w[["lambda"]],
    gamma = w[["gamma"]]
  )
}
