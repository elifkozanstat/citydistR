\name{detour_factor}
\alias{detour_factor}
\title{Compute Detour Factors}
\description{
Computes the ratio between network distance and Euclidean distance.
}
\usage{
detour_factor(
  network_distance,
  euclidean_distance,
  eps = 1e-08,
  min_df = 0,
  max_df = Inf,
  invalid = c("na", "error")
)
}
\arguments{
  \item{network_distance}{Numeric vector of network or shortest-path distances.}
  \item{euclidean_distance}{Numeric vector of Euclidean distances.}
  \item{eps}{Small positive constant used for numerical protection.}
  \item{min_df}{Lower clipping bound for valid detour factors.}
  \item{max_df}{Upper clipping bound for valid detour factors.}
  \item{invalid}{How to handle non-positive Euclidean distances: \code{"na"} or \code{"error"}.}
}
\value{
A numeric vector of detour factors.
}
\examples{
detour_factor(c(12, 25), c(10, 20))
}
