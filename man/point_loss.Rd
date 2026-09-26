\name{point_loss}
\alias{point_loss}
\title{Pointwise Loss Aggregator}
\description{
Computes a mean pointwise loss from residuals using a selectable loss family.
}
\usage{
point_loss(
  residuals,
  method = c("mse", "mae", "huber", "logcosh"),
  delta = 1,
  na.rm = TRUE
)
}
\arguments{
  \item{residuals}{Numeric residual vector.}
  \item{method}{Loss family: \code{"mse"}, \code{"mae"}, \code{"huber"}, or \code{"logcosh"}.}
  \item{delta}{Positive Huber transition parameter.}
  \item{na.rm}{Logical; remove missing and non-finite residuals.}
}
\value{
A single numeric loss value.
}
\examples{
point_loss(c(-2, -1, 0, 1, 2), "huber", delta = 1)
}
