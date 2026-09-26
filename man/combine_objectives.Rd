\name{combine_objectives}
\alias{combine_objectives}
\title{Combine Objective Components}
\description{
Combines scalar objective components with configurable weights.
}
\usage{
combine_objectives(components, weights = NULL)
}
\arguments{
  \item{components}{Named or unnamed numeric vector of scalar objective components.}
  \item{weights}{Optional named or positional numeric vector of weights.}
}
\value{
A single weighted objective value.
}
\examples{
combine_objectives(c(a = 1, b = 2), c(a = 2, b = 3))
}
