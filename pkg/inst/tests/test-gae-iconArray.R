test_that("iconArray works on gae dev server", {
  require(MASS)
  require(nnet)
  require(colorspace)
  mobj=multinom(Age~Eth+Sex+Lrn+Days, data=quine)
  visMobj=iconArrayVis(mobj=mobj, data=quine, colors=rainbow_hcl(4, start=50, end=270), init.color="lightgray", plot.title="School Absenteeism", gaeDevel=FALSE)
  expect_that(visMobj@serverID!="error", is_true())
})
