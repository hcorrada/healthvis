test_that("distance matrix works on gae dev server", {
  mat = as.matrix(mtcars) 
  brand = factor(sapply(strsplit(rownames(mat),split=" "),function(i)i[[1]]))
  visDist=distVis(mat,factors=brand, gaeDevel=T)
  expect_that(visDist@serverID!="error", is_true())
})
