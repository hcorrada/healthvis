test_that("accuracy table works", {
  obj=accuracyTableVis(local=TRUE, plot=TRUE)
  expect_that(obj@serverID!="error", is_true())
})

test_that("accuracy table works on gae", {
  obj=accuracyTableVis(local=FALSE, plot=TRUE)
  expect_that(obj@serverID!="error", is_true())
})