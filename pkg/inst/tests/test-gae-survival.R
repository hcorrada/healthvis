test_that("survival works on gae dev server", {
  require(survival)
  cobj=coxph(Surv(time, status) ~ trt+age+celltype,data=veteran)  
  visCobj=survivalVis(cobj, veteran, plot.title="Veteran survival test", gaeDevel=FALSE, plot=TRUE)
  expect_that(visCobj@serverID!="error", is_true())
})
