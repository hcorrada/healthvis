test_that("accuracy table works on gae", {
  obj=accuracyTableVis(gaeDevel=FALSE, plot=TRUE)
  expect_that(obj@serverID!="error", is_true())
})
