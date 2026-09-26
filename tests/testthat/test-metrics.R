test_that("detour factors and city indices are computed", {
  d <- detour_factor(c(20, 30, 45), c(10, 20, 30))
  expect_equal(d, c(2, 1.5, 1.5))

  idx <- city_indices(detour = d)
  expect_equal(idx$n, 3)
  expect_true(is.finite(idx$TPI))
  expect_true(is.finite(idx$Tail95))
})

test_that("robust activation follows the threshold", {
  expect_false(robust_loss_active(1.34, 1.35))
  expect_true(robust_loss_active(1.35, 1.35))
  expect_true(robust_loss_active(1.50, 1.35))
})
