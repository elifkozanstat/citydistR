# citydistR

`citydistR` provides modular R utilities for distribution-aware and city-adaptive
analysis of learning-based road-network distance estimates.

The package was prepared as a software dissemination output of the research
project **New Optimization Procedures in Machine Learning Algorithms**.

## Design principle

The package is **not tied to one fixed loss function, optimizer, or neural-network
architecture**. The road-network manuscript evaluates one specific configuration,
but the software exposes reusable pieces so that alternative robust losses,
weights, structural indicators, and objective combinations can be investigated.

The current release includes:

- detour-factor calculation;
- Topological Predictability Index (TPI);
- Tail95 detour-heaviness index;
- automatic robust-loss activation;
- MSE, MAE, Huber and log-cosh point losses;
- median-based detour regularization;
- modular weighted objective composition;
- a manuscript-aligned hybrid objective;
- city-adaptive validation weights and validation score;
- MAE, RMSE, P95, bias and Spearman evaluation utilities;
- multi-model comparison helpers.

## Installation from a local folder

```r
install.packages("path/to/citydistR", repos = NULL, type = "source")
```

Or, from the repository root:

```r
R CMD INSTALL citydistR
```

## Installation from GitHub

After the repository is created and `elifkozanstat` is replaced in
`DESCRIPTION`:

```r
install.packages("remotes")
remotes::install_github("elifkozanstat/citydistR")
```

## Quick example

```r
library(citydistR)

network <- c(12, 18, 31, 45, 70)
euclid  <- c(10, 15, 25, 35, 40)
pred    <- c(11, 20, 29, 48, 63)

df <- detour_factor(network, euclid)
city_indices(detour = df)

hybrid_objective(
  true_distance = network,
  pred_distance = pred,
  euclidean_distance = euclid,
  loss = "auto",
  tail95_value = tail95(df)
)

adaptive_validation_score(
  true_distance = network,
  pred_distance = pred,
  tail95_value = tail95(df),
  tpi_value = tpi(df)
)

evaluate_distance_model(network, pred)
```

## Alternative loss combinations

The manuscript-aligned objective is only one configuration. For example:

```r
parts <- c(
  distance = point_loss(c(-1, 0.5, 3), method = "huber"),
  geometry = point_loss(c(0.1, -0.2, 0.4), method = "logcosh"),
  stability = 0.15
)

combine_objectives(
  parts,
  weights = c(distance = 1, geometry = 0.7, stability = 0.2)
)
```

## Tested road-network configuration

The research manuscript uses a city-adaptive configuration in which training-set
Tail95 and TPI values inform robustness and validation. The reported robust-loss
activation threshold is `Tail95 >= 1.35`. This default is included for
reproducibility, but users can provide another threshold.

## Development status

Version `0.1.1` is a source release prepared for public dissemination and
CRAN submission. The package has passed local `R CMD check --as-cran`
with 0 errors and 0 warnings and has also passed Win-builder R-devel
checks with 0 errors and 0 warnings.

## Funding

Development of `citydistR` was supported by the Scientific and Technological
Research Council of Türkiye (TÜBİTAK) under the 2219 International Postdoctoral
Research Fellowship Programme.
