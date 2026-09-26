\name{median_df_regularization}
\alias{median_df_regularization}
\title{Median-Based Detour Regularization}
\description{
Penalizes dispersion of predicted detour factors around their median.
}
\usage{
median_df_regularization(
  pred_distance,
  euclidean_distance,
  eps = 1e-08,
  df_min = 0,
  df_max = Inf
)
}
\arguments{
  \item{pred_distance}{Numeric vector of predicted network distances.}
  \item{euclidean_distance}{Numeric vector of Euclidean distances.}
  \item{eps}{Small positive constant.}
  \item{df_min}{Lower clipping bound for predicted detour factors.}
  \item{df_max}{Upper clipping bound for predicted detour factors.}
}
\value{
A single numeric regularization value.
}
\examples{
median_df_regularization(c(12, 18, 26), c(10, 15, 20))
}
