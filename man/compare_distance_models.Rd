\name{compare_distance_models}
\alias{compare_distance_models}
\title{Compare Distance-Prediction Models}
\description{
Evaluates multiple named prediction vectors using a common metric set.
}
\usage{
compare_distance_models(true_distance, predictions, p = 0.95)
}
\arguments{
  \item{true_distance}{Numeric vector of true distances.}
  \item{predictions}{Named list of numeric prediction vectors.}
  \item{p}{Tail probability for high-quantile absolute error.}
}
\value{
A data frame containing one row per model.
}
\examples{
compare_distance_models(
  c(10, 20, 30),
  list(a = c(11, 19, 31), b = c(12, 18, 32))
)
}
