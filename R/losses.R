
#' Pointwise loss aggregator
#'
#' Computes a mean loss from residuals. Multiple loss families are available so
#' that the framework is not tied to one robust estimator.
#'
#' @param residuals Numeric residual vector.
#' @param method One of `"mse"`, `"mae"`, `"huber"` or `"logcosh"`.
#' @param delta Positive Huber transition parameter.
#' @param na.rm Logical; remove missing and non-finite residuals.
#'
#' @return A single numeric loss value.
#' @export
#'
#' @examples
#' point_loss(c(-2, -1, 0, 1, 2), "huber", delta = 1)
point_loss <- function(residuals,
                       method = c("mse", "mae", "huber", "logcosh"),
                       delta = 1, na.rm = TRUE) {
  method <- match.arg(method)
  .assert_numeric(residuals, "residuals")
  x <- .clean_finite(residuals, na.rm = na.rm)
  if (length(x) == 0L) return(NA_real_)
  if (!is.finite(delta) || delta <= 0) {
    stop("`delta` must be positive.", call. = FALSE)
  }

  if (method == "mse") return(mean(x^2))
  if (method == "mae") return(mean(abs(x)))

  if (method == "huber") {
    a <- abs(x)
    values <- ifelse(a <= delta, 0.5 * x^2, delta * (a - 0.5 * delta))
    return(mean(values))
  }

  # numerically stable log(cosh(x))
  a <- abs(x)
  mean(a + log1p(exp(-2 * a)) - log(2))
}

#' Median-based regularization of predicted detour factors
#'
#' Penalizes dispersion around the median predicted detour factor.
#'
#' @param pred_distance Numeric vector of predicted network distances.
#' @param euclidean_distance Numeric vector of Euclidean distances.
#' @param eps Small positive constant.
#' @param df_min Lower clipping bound for predicted detour factors.
#' @param df_max Upper clipping bound for predicted detour factors.
#'
#' @return A single numeric regularization value.
#' @export
#'
#' @examples
#' median_df_regularization(c(12, 18, 26), c(10, 15, 20))
median_df_regularization <- function(pred_distance, euclidean_distance,
                                     eps = 1e-8, df_min = 0,
                                     df_max = Inf) {
  pred_df <- detour_factor(pred_distance, euclidean_distance,
                           eps = eps, min_df = df_min, max_df = df_max)
  pred_df <- pred_df[is.finite(pred_df)]
  if (length(pred_df) == 0L) return(NA_real_)
  med <- stats::median(pred_df)
  mean((pred_df - med)^2)
}

#' Combine named objective components
#'
#' Provides a generic weighted combination of scalar objective components.
#' This function can be used to construct alternative loss combinations.
#'
#' @param components Named numeric vector of scalar loss components.
#' @param weights Optional named or positional numeric vector of weights.
#'
#' @return A single weighted objective value.
#' @export
#'
#' @examples
#' combine_objectives(c(distance = 1.2, geometry = 0.4, stability = 0.1),
#'                    c(1, 0.5, 0.2))
combine_objectives <- function(components, weights = NULL) {
  .assert_numeric(components, "components")
  if (length(components) == 0L || any(!is.finite(components))) {
    stop("`components` must contain finite scalar values.", call. = FALSE)
  }
  if (is.null(weights)) weights <- rep(1, length(components))
  .assert_numeric(weights, "weights")

  if (!is.null(names(weights)) && !is.null(names(components))) {
    missing_names <- setdiff(names(components), names(weights))
    if (length(missing_names) > 0L) {
      stop("Named `weights` must cover all named `components`.", call. = FALSE)
    }
    weights <- weights[names(components)]
  }

  if (length(weights) != length(components)) {
    stop("`weights` and `components` must have the same length.", call. = FALSE)
  }
  if (any(!is.finite(weights))) {
    stop("`weights` must be finite.", call. = FALSE)
  }
  sum(components * weights)
}

#' Modular hybrid objective for road-network distance estimates
#'
#' Computes a three-component objective: absolute-distance loss, logarithmic
#' detour-factor loss, and median-based detour regularization. The point loss may
#' be selected explicitly or chosen automatically from a Tail95 threshold.
#'
#' @param true_distance Numeric vector of true network distances.
#' @param pred_distance Numeric vector of predicted network distances.
#' @param euclidean_distance Numeric vector of Euclidean distances.
#' @param beta_logdf Weight for the log-detour component.
#' @param beta_median Weight for median-based regularization.
#' @param loss One of `"auto"`, `"mse"`, `"mae"`, `"huber"` or `"logcosh"`.
#' @param tail95_value Optional Tail95 value used when `loss = "auto"`.
#' @param robust_threshold Tail95 threshold for automatic Huber activation.
#' @param delta Huber transition parameter.
#' @param standardize Logical; standardize distance and log-detour targets using
#'   statistics from the true values before computing point losses.
#' @param eps Small positive constant.
#' @param df_min Lower clipping bound for detour factors.
#' @param df_max Upper clipping bound for detour factors.
#'
#' @return A list containing total loss, component losses and the selected point
#'   loss method.
#' @export
#'
#' @examples
#' y <- c(12, 18, 31, 45)
#' yhat <- c(11, 20, 29, 48)
#' d <- c(10, 15, 25, 35)
#' hybrid_objective(y, yhat, d, loss = "mse")
hybrid_objective <- function(true_distance, pred_distance, euclidean_distance,
                             beta_logdf = 1, beta_median = 0.1,
                             loss = c("auto", "mse", "mae", "huber", "logcosh"),
                             tail95_value = NULL, robust_threshold = 1.35,
                             delta = 1, standardize = TRUE,
                             eps = 1e-8, df_min = 1e-8, df_max = Inf) {
  loss <- match.arg(loss)
  .assert_numeric(true_distance, "true_distance")
  .assert_numeric(pred_distance, "pred_distance")
  .assert_numeric(euclidean_distance, "euclidean_distance")
  .assert_same_length(true_distance, pred_distance,
                      "true_distance", "pred_distance")
  .assert_same_length(true_distance, euclidean_distance,
                      "true_distance", "euclidean_distance")

  ok <- is.finite(true_distance) & is.finite(pred_distance) &
    is.finite(euclidean_distance) & euclidean_distance > 0
  if (!any(ok)) stop("No valid observations remain.", call. = FALSE)

  y <- true_distance[ok]
  yh <- pmax(pred_distance[ok], eps)
  d <- euclidean_distance[ok]

  selected <- loss
  if (loss == "auto") {
    if (is.null(tail95_value)) {
      tail95_value <- tail95(detour_factor(y, d, eps = eps,
                                          min_df = df_min, max_df = df_max))
    }
    selected <- if (robust_loss_active(tail95_value, robust_threshold)) {
      "huber"
    } else {
      "mse"
    }
  }

  if (standardize) {
    sy <- .safe_scale(y, eps = eps)
    y_z <- sy$z
    yh_z <- (yh - sy$center) / sy$scale
    l_distance <- point_loss(yh_z - y_z, selected, delta = delta)

    df_true <- detour_factor(y, d, eps = eps,
                             min_df = df_min, max_df = df_max)
    df_pred <- detour_factor(yh, d, eps = eps,
                             min_df = df_min, max_df = df_max)
    log_true <- log(pmax(df_true, eps))
    log_pred <- log(pmax(df_pred, eps))
    sl <- .safe_scale(log_true, eps = eps)
    log_true_z <- sl$z
    log_pred_z <- (log_pred - sl$center) / sl$scale
    l_logdf <- point_loss(log_pred_z - log_true_z, selected, delta = delta)
  } else {
    l_distance <- point_loss(yh - y, selected, delta = delta)
    df_true <- detour_factor(y, d, eps = eps,
                             min_df = df_min, max_df = df_max)
    df_pred <- detour_factor(yh, d, eps = eps,
                             min_df = df_min, max_df = df_max)
    l_logdf <- point_loss(log(pmax(df_pred, eps)) -
                            log(pmax(df_true, eps)),
                          selected, delta = delta)
  }

  l_median <- median_df_regularization(yh, d, eps = eps,
                                       df_min = df_min, df_max = df_max)
  total <- combine_objectives(
    c(distance = l_distance, log_detour = l_logdf, median = l_median),
    c(distance = 1, log_detour = beta_logdf, median = beta_median)
  )

  list(
    total = total,
    distance = l_distance,
    log_detour = l_logdf,
    median = l_median,
    point_loss = selected,
    beta_logdf = beta_logdf,
    beta_median = beta_median
  )
}
