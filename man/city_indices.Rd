\name{city_indices}
\alias{city_indices}
\title{City-Level Detour Diagnostics}
\description{
Returns TPI, Tail95, and descriptive statistics for detour factors.
}
\usage{
city_indices(
  network_distance = NULL,
  euclidean_distance = NULL,
  detour = NULL,
  eps = 1e-08,
  na.rm = TRUE
)
}
\arguments{
  \item{network_distance}{Optional numeric vector of network distances.}
  \item{euclidean_distance}{Optional numeric vector of Euclidean distances.}
  \item{detour}{Optional numeric vector of pre-computed detour factors.}
  \item{eps}{Small positive constant.}
  \item{na.rm}{Logical; remove missing and non-finite values.}
}
\value{
A one-row data frame containing city-level diagnostics.
}
\examples{
city_indices(detour = c(1.0, 1.1, 1.2, 1.4, 2.5))
}
