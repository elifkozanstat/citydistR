
#' Evaluate distance predictions
#'
#' Computes average, tail and ranking metrics for distance predictions.
#'
#' @param true_distance Numeric vector of true distances.
#' @param pred_distance Numeric vector of predicted distances.
#' @param p Tail probability used for the high-quantile absolute error.
#'
#' @return A one-row data frame with `n`, `MAE`, `RMSE`, `P95`, `Bias`, and
#'   `Spearman`.
#' @export
#'
#' @examples
#' evaluate_distance_model(c(10, 20, 30), c(11, 18, 33))
evaluate_distance_model <- function(true_distance, pred_distance, p = 0.95) {
  .assert_numeric(true_distance, "true_distance")
  .assert_numeric(pred_distance, "pred_distance")
  .assert_same_length(true_distance, pred_distance,
                      "true_distance", "pred_distance")
  ok <- is.finite(true_distance) & is.finite(pred_distance)
  y <- true_distance[ok]
  yh <- pred_distance[ok]
  if (length(y) == 0L) stop("No valid observations remain.", call. = FALSE)

  e <- yh - y
  ae <- abs(e)
  rho <- if (length(y) >= 2L) {
    suppressWarnings(stats::cor(y, yh, method = "spearman"))
  } else NA_real_

  data.frame(
    n = length(y),
    MAE = mean(ae),
    RMSE = sqrt(mean(e^2)),
    P95 = as.numeric(stats::quantile(ae, probs = p, names = FALSE, type = 7)),
    Bias = mean(e),
    Spearman = rho
  )
}

#' Compare several distance-prediction models
#'
#' @param true_distance Numeric vector of true distances.
#' @param predictions Named list of numeric prediction vectors.
#' @param p Tail probability for high-quantile absolute error.
#'
#' @return A data frame containing one row per model.
#' @export
#'
#' @examples
#' y <- c(10, 20, 30, 40)
#' preds <- list(model_a = c(11, 19, 31, 39),
#'               model_b = c(12, 18, 33, 38))
#' compare_distance_models(y, preds)
compare_distance_models <- function(true_distance, predictions, p = 0.95) {
  .assert_numeric(true_distance, "true_distance")
  if (!is.list(predictions) || length(predictions) == 0L) {
    stop("`predictions` must be a non-empty list.", call. = FALSE)
  }
  if (is.null(names(predictions)) || any(names(predictions) == "")) {
    names(predictions) <- paste0("model_", seq_along(predictions))
  }

  out <- lapply(seq_along(predictions), function(i) {
    res <- evaluate_distance_model(true_distance, predictions[[i]], p = p)
    data.frame(model = names(predictions)[i], res, check.names = FALSE)
  })
  do.call(rbind, out)
}
