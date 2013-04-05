test_that("paired scatter works on gae devel server", {
  test_data <- iris
  test_data$content <- sample(c("High", "Med", "Low", "None"), nrow(test_data), replace=T)
  pairedVis(test_data, plot.title="Iris Scatterplot")

  obj=pairedVis(test_data, gaeDevel=TRUE, plot=TRUE)
  expect_that(obj@serverID!="error", is_true())
})
