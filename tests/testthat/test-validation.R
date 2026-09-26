test_that("adaptive weights stay in expected ranges", {
  w <- adaptive_weights(1.5, 0.8, tail95_sat = 2,
                        lambda_max = 2, gamma_max = 3)
  expect_gte(w[["lambda"]], 0)
  expect_lte(w[["lambda"]], 2)
  expect_gte(w[["gamma"]], 0)
  expect_lte(w[["gamma"]], 3)
})

test_that("validation score and model evaluation are finite", {
  y <- c(10, 20, 30, 40, 50)
  yh <- c(11, 18, 32, 39, 52)

  s <- adaptive_validation_score(y, yh, 1.5, 0.8)
  expect_true(is.finite(s[["score"]]))

  ev <- evaluate_distance_model(y, yh)
  expect_equal(ev$n, 5)
  expect_true(all(is.finite(unlist(ev[, c("MAE", "RMSE", "P95", "Bias", "Spearman")]))))
})
