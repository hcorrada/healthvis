test_that("survival works", {
  require(survival)
  cobj=coxph(Surv(time, status) ~ trt+age+celltype,data=veteran)  
  visCobj=survivalVis(cobj, veteran, plot.title="Veteran survival test", local=TRUE, plot=TRUE)
  expect_that(visCobj@serverID!="error", is_true())
})

test_that("survival works on gae", {
  cobj=coxph(Surv(time, status) ~ trt+age+celltype,data=veteran)  
  visCobj=survivalVis(cobj, veteran, plot.title="Veteran survival test", local=FALSE, plot=TRUE)
  expect_that(visCobj@serverID!="error", is_true())
})