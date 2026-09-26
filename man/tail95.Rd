\name{tail95}
\alias{tail95}
\title{Tail95 Detour-Heaviness Index}
\description{
Computes an upper-quantile detour-factor summary relative to the median.
}
\usage{
tail95(detour, prob = 0.95, eps = 1e-08, na.rm = TRUE)
}
\arguments{
  \item{detour}{Numeric vector of detour factors.}
  \item{prob}{Quantile probability.}
  \item{eps}{Small positive constant for numerical protection.}
  \item{na.rm}{Logical; remove missing and non-finite values.}
}
\value{
A single numeric tail-heaviness value.
}
\examples{
tail95(c(1.0, 1.1, 1.2, 1.4, 2.5))
}
