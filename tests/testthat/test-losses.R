test_that("point losses are finite", {
  r <- c(-2, -1, 0, 1, 2)
  expect_true(is.finite(point_loss(r, "mse")))
  expect_true(is.finite(point_loss(r, "mae")))
  expect_true(is.finite(point_loss(r, "huber")))
  expect_true(is.finite(point_loss(r, "logcosh")))
})

test_that("hybrid objective exposes modular components", {
  y <- c(12, 18, 31, 45)
  yh <- c(11, 20, 29, 48)
  d <- c(10, 15, 25, 35)

  h <- hybrid_objective(y, yh, d, loss = "mse")
  expect_true(all(c("total", "distance", "log_detour", "median") %in% names(h)))
  expect_true(is.finite(h$total))
})

test_that("generic objective combination works", {
  x <- combine_objectives(c(a = 1, b = 2), c(a = 2, b = 3))
  expect_equal(x, 8)
})
