\name{evaluate_distance_model}
\alias{evaluate_distance_model}
\title{Evaluate Distance Predictions}
\description{
Computes average, tail, bias, and ranking metrics for distance predictions.
}
\usage{
evaluate_distance_model(true_distance, pred_distance, p = 0.95)
}
\arguments{
  \item{true_distance}{Numeric vector of true distances.}
  \item{pred_distance}{Numeric vector of predicted distances.}
  \item{p}{Tail probability used for the high-quantile absolute error.}
}
\value{
A one-row data frame with sample size, MAE, RMSE, P95, bias, and Spearman correlation.
}
\examples{
evaluate_distance_model(c(10, 20, 30), c(11, 18, 33))
}
