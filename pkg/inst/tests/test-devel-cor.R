test_that("distance matrix works on gae dev server", {
  mat = as.matrix(mtcars) 
  brand = factor(sapply(strsplit(rownames(mat),split=" "),function(i)i[[1]]))
  corDist=corVis(mat,factors=brand, gaeDevel=T)
  expect_that(corDist@serverID!="error", is_true())
})
