test_that("survival works on gae dev server", {
  require(survival)
  require(colorspace)
  cobj=coxph(Surv(time, status) ~ trt+age+celltype+prior,data=veteran)  
  visCobj=survivalVis(cobj, data=veteran, plot.title="Veteran survival test", group="trt", group.names=c("Treatment", "No Treatment"), line.col=rainbow_hcl(2, start=50, end=270),gaeDevel=FALSE, plot=TRUE)
  expect_that(visCobj@serverID!="error", is_true())
})
