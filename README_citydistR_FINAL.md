# citydistR

`citydistR` provides modular R utilities for distribution-aware and city-adaptive analysis of learning-based road-network distance estimates.

The package was prepared as a software dissemination output of the research project **New Optimization Procedures in Machine Learning Algorithms**.

## Design principle

The package is **not tied to one fixed loss function, optimizer, neural-network architecture, or prediction model**. The road-network manuscript evaluates one specific configuration, but the software exposes reusable pieces so that alternative robust losses, weights, structural indicators, objective combinations, and prediction models can be investigated.

Distance predictions may therefore come from a neural network, regression model, tree-based method, or another modelling approach.

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

## What data does citydistR need?

`citydistR` works with numeric vectors corresponding to the same origin-destination pairs.

The main inputs are:

- `network_distance` or `true_distance`: the observed shortest-path distance along the road network;
- `euclidean_distance`: the corresponding straight-line or geometric distance;
- `pred_distance`: the predicted road-network distance produced by an external model.

The first two quantities are sufficient for detour-factor and city-structure analysis. The prediction vector is required when model performance or prediction-based objectives are evaluated.

A typical input structure is:

| true_distance | euclidean_distance | pred_distance |
|--------------:|-------------------:|--------------:|
| 12.4 | 9.7 | 11.9 |
| 18.2 | 13.5 | 19.1 |
| 7.6 | 6.9 | 7.4 |

## Key structural indicators

### Detour factor

For an origin-destination pair, the detour factor is defined as

\[
DF = \frac{\text{network distance}}{\text{euclidean distance}}
\]

It measures how much longer the actual road-network path is than the corresponding straight-line distance.

A value close to 1 indicates that the road-network path is relatively direct, whereas larger values indicate stronger detours caused by road layout, barriers, sparse connectivity, or other structural characteristics.

### Topological Predictability Index (TPI)

The Topological Predictability Index summarizes the variability of detour factors within a road network:

\[
TPI = \frac{1}{1 + CV(DF)}
\]

where

\[
CV(DF) = \frac{SD(DF)}{Mean(DF)}
\]

is the coefficient of variation of the detour-factor distribution.

TPI takes values between 0 and 1.

- Higher TPI values indicate more stable and predictable relationships between geometric distance and road-network distance.
- Lower TPI values indicate greater heterogeneity in detour behaviour and potentially more difficult distance prediction.

### Tail95

Tail95 summarizes the upper-tail behaviour of the detour-factor distribution:

\[
Tail95 =
\frac{Q_{0.95}(DF)}
{Median(DF)}
\]

where \(Q_{0.95}(DF)\) is the 95th percentile of the detour factors.

A larger Tail95 value indicates stronger extreme-detour behaviour. In the associated city-adaptive framework, Tail95 is used to inform robustness decisions, including whether a robust loss such as Huber loss should be activated.

## Typical workflow

A typical workflow is:

1. Construct origin-destination pairs from a road network.
2. Compute the true shortest-path distance for each pair.
3. Compute the corresponding geometric or Euclidean distance.
4. Optionally train a prediction model in Python, R, or another environment.
5. Obtain predicted road-network distances.
6. Use `citydistR` to analyse detour structure, evaluate predictions, construct hybrid objectives, and apply adaptive validation criteria.

In the associated road-network study, the predictive model was trained externally in Python/PyTorch using Euclidean distance and coordinate differences as input features, with the true shortest-path distance as the prediction target.

## What citydistR does not do

`citydistR` does not currently train a neural network or another prediction model.

It also does not compute shortest paths directly from raw latitude/longitude coordinates and does not construct a road-network graph from geographic coordinates.

These steps are expected to be performed before using the package. `citydistR` focuses on the reusable analysis, robustness, objective-design, validation, and model-evaluation components that operate on the resulting distance and prediction vectors.

## Reproducibility note

When reproducing the associated city-adaptive modelling workflow, structural indicators such as TPI and Tail95 should be calculated from the training data rather than from the held-out test data.

The test data can then be used for final evaluation of model predictions.

## Installation from a local folder

```r
install.packages("path/to/citydistR", repos = NULL, type = "source")
```

Or, from the repository root:

```bash
R CMD INSTALL citydistR
```

## Installation from GitHub

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

df <- detour_factor(
  network_distance = network,
  euclidean_distance = euclid
)

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

evaluate_distance_model(
  true_distance = network,
  pred_distance = pred
)
```

## Custom objective composition

The manuscript-aligned hybrid objective is one possible configuration. The `combine_objectives()` function allows users to combine externally defined scalar objective components using user-specified weights. This provides flexibility for experimenting with objective formulations beyond the manuscript-aligned configuration.

## Tested road-network configuration

The research manuscript uses a city-adaptive configuration in which training-set Tail95 and TPI values inform robustness and validation.

The reported robust-loss activation threshold is:

```text
Tail95 >= 1.35
```

This default is included for reproducibility, but users can provide another threshold.

## Development status

Version `0.1.1` is the current public GitHub source release.

The package has passed local `R CMD check --as-cran` with 0 errors and 0 warnings and has also passed Win-builder R-devel checks with 0 errors and 0 warnings.

Version `0.1.0` has been submitted to CRAN and, at the time of this README update, is under CRAN review.

## Funding

Development of `citydistR` was supported by the Scientific and Technological Research Council of Türkiye (TÜBİTAK) under the 2219 International Postdoctoral Research Fellowship Programme.
