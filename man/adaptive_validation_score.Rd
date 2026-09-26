\name{adaptive_validation_score}
\alias{adaptive_validation_score}
\title{City-Adaptive Validation Score}
\description{
Combines normalized MAE, normalized P95 absolute error, and Spearman rank
correlation. Lower values indicate better validation performance.
}
\usage{
adaptive_validation_score(
  true_distance,
  pred_distance,
  tail95_value,
  tpi_value,
  tail95_sat = 2,
  lambda_max = 1,
  gamma_max = 1,
  eps = 1e-08
)
}
\arguments{
  \item{true_distance}{Numeric vector of true distances.}
  \item{pred_distance}{Numeric vector of predicted distances.}
  \item{tail95_value}{Numeric Tail95 value computed from training data.}
  \item{tpi_value}{Numeric TPI value computed from training data.}
  \item{tail95_sat}{Tail95 saturation constant.}
  \item{lambda_max}{Maximum tail-risk weight.}
  \item{gamma_max}{Maximum ranking-consistency weight.}
  \item{eps}{Small positive constant.}
}
\value{
A named numeric vector containing the score and its components.
}
\examples{
adaptive_validation_score(
  c(10, 20, 30),
  c(11, 19, 32),
  tail95_value = 1.5,
  tpi_value = 0.8
)
}
