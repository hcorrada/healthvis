test_that("accuracy table works on gae dev server", {
  obj=accuracyTableVis(gae="local", plot=TRUE)
  expect_that(obj@serverID!="error", is_true())
})

