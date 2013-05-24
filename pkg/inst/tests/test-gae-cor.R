test_that("distance matrix works on gae", {
  mat = as.matrix(mtcars) 
  brand = factor(sapply(strsplit(rownames(mat),split=" "),function(i)i[[1]]))
  corDist=corVis(mat,factors=brand, gaeDevel=F)
  expect_that(corDist@serverID!="error", is_true())
})
