test_that("distance matrix works on gae dev server", {
  mat = as.matrix(mtcars) 
  visDist=distVis(mat, gaeDevel=F)
  expect_that(visDist@serverID!="error", is_true())
})
