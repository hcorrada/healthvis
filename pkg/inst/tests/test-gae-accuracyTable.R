test_that("accuracy table works on gae", {
  obj=accuracyTableVis(gae="remote", plot=TRUE)
  expect_that(obj@serverID!="error", is_true())
})
