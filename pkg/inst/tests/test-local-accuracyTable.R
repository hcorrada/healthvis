test_that("accuracy table works on local host", {
  obj=accuracyTableVis(gae="none", plot=TRUE)
  expect_that(obj@serverID!="error",is_true())
})