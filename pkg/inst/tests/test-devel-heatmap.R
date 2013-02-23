test_that("heatmap works on gae dev server", {
  data1 <- matrix(rnorm(150), 25, 6)
  rownames(data1) <- 1:25
  colnames(data1) <- c("V1", "V2", "V3", "V4", "V5", "V6")

  sort.by1 <- data.frame("Ind"=rbinom(25, 1, 0.4), "Age"=rpois(25, 30))

  visHeat=heatmapVis(data=data1, sort.by=sort.by1, gaeDevel=T)
  expect_that(visHeat@serverID!="error", is_true())
})
