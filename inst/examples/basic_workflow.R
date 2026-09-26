library(citydistR)

network <- c(12, 18, 31, 45, 70, 92)
euclid  <- c(10, 15, 25, 35, 40, 65)
pred_a  <- c(11, 20, 29, 48, 63, 95)
pred_b  <- c(12, 19, 32, 44, 68, 90)

df <- detour_factor(network, euclid)
print(city_indices(detour = df))

print(hybrid_objective(
  true_distance = network,
  pred_distance = pred_a,
  euclidean_distance = euclid,
  loss = "auto",
  tail95_value = tail95(df)
))

print(adaptive_validation_score(
  true_distance = network,
  pred_distance = pred_a,
  tail95_value = tail95(df),
  tpi_value = tpi(df)
))

print(compare_distance_models(
  network,
  list(hybrid_candidate = pred_a, alternative_candidate = pred_b)
))
