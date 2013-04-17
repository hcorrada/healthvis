test_that("distance matrix works on gae", {
  mat = as.matrix(mtcars) 
  brand = factor(sapply(strsplit(rownames(mat),split=" "),function(i)i[[1]]))
  visDist=distVis(mat,factors=brand, gaeDevel=F)
  expect_that(visDist@serverID!="error", is_true())
})
