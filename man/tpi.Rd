\name{tpi}
\alias{tpi}
\title{Topological Predictability Index}
\description{
Computes the Topological Predictability Index (TPI) from detour factors.
}
\usage{
tpi(detour, eps = 1e-08, na.rm = TRUE)
}
\arguments{
  \item{detour}{Numeric vector of detour factors.}
  \item{eps}{Small positive constant.}
  \item{na.rm}{Logical; remove missing and non-finite values.}
}
\value{
A single numeric TPI value.
}
\examples{
tpi(c(1.0, 1.1, 1.3, 1.8))
}
