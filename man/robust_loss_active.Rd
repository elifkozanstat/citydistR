\name{robust_loss_active}
\alias{robust_loss_active}
\title{Robust-Loss Activation Rule}
\description{
Checks whether Tail95 reaches a configurable robust-loss activation threshold.
}
\usage{
robust_loss_active(tail95_value, threshold = 1.35)
}
\arguments{
  \item{tail95_value}{Numeric Tail95 value.}
  \item{threshold}{Numeric activation threshold.}
}
\value{
A logical value.
}
\examples{
robust_loss_active(1.42)
}
