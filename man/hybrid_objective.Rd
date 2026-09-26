\name{hybrid_objective}
\alias{hybrid_objective}
\title{Modular Hybrid Objective}
\description{
Combines distance loss, log-detour loss, and median-based detour regularization.
The point-loss family is configurable.
}
\usage{
hybrid_objective(
  true_distance,
  pred_distance,
  euclidean_distance,
  beta_logdf = 1,
  beta_median = 0.1,
  loss = c("auto", "mse", "mae", "huber", "logcosh"),
  tail95_value = NULL,
  robust_threshold = 1.35,
  delta = 1,
  standardize = TRUE,
  eps = 1e-08,
  df_min = 1e-08,
  df_max = Inf
)
}
\arguments{
  \item{true_distance}{Numeric vector of true network distances.}
  \item{pred_distance}{Numeric vector of predicted network distances.}
  \item{euclidean_distance}{Numeric vector of Euclidean distances.}
  \item{beta_logdf}{Weight for the log-detour objective component.}
  \item{beta_median}{Weight for the median regularization component.}
  \item{loss}{Point-loss choice: \code{"auto"}, \code{"mse"}, \code{"mae"}, \code{"huber"}, or \code{"logcosh"}.}
  \item{tail95_value}{Optional Tail95 value used when \code{loss = "auto"}.}
  \item{robust_threshold}{Tail95 threshold used for automatic Huber activation.}
  \item{delta}{Positive Huber transition parameter.}
  \item{standardize}{Logical; standardize distance and log-detour targets before point-loss calculation.}
  \item{eps}{Small positive constant.}
  \item{df_min}{Lower clipping bound for detour factors.}
  \item{df_max}{Upper clipping bound for detour factors.}
}
\value{
A list containing total loss, component losses, and the selected point-loss method.
}
\examples{
hybrid_objective(
  c(12, 18, 31),
  c(11, 20, 29),
  c(10, 15, 25),
  loss = "mse"
)
}
