\name{adaptive_weights}
\alias{adaptive_weights}
\title{City-Adaptive Validation Weights}
\description{
Computes tail-risk and ranking-consistency weights from Tail95 and TPI.
}
\usage{
adaptive_weights(
  tail95_value,
  tpi_value,
  tail95_sat = 2,
  lambda_max = 1,
  gamma_max = 1
)
}
\arguments{
  \item{tail95_value}{Numeric Tail95 value.}
  \item{tpi_value}{Numeric TPI value.}
  \item{tail95_sat}{Tail95 saturation constant; must exceed 1.}
  \item{lambda_max}{Maximum tail-risk weight.}
  \item{gamma_max}{Maximum ranking-consistency weight.}
}
\value{
A named numeric vector containing \code{lambda}, \code{gamma}, and \code{normalized_tail}.
}
\examples{
adaptive_weights(1.6, 0.78)
}
