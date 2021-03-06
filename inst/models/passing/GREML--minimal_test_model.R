require(OpenMx)

set.seed(1234)
dat <- cbind(rnorm(100),rep(1,100))
colnames(dat) <- c("y","x")

ge <- mxExpectationGREML(V="V",yvars="y", Xvars="x", addOnes=FALSE)
gff <- mxFitFunctionGREML(dV=c(ve="I"))
plan <- mxComputeSequence(steps=list(
  mxComputeNewtonRaphson(freeSet=c("Ve"),fitfunction="fitfunction"),
  mxComputeOnce('fitfunction', c('fit','gradient','hessian','ihessian'),freeSet=c("Ve")),
  mxComputeStandardError(freeSet=c("Ve")),
  mxComputeReportDeriv(freeSet=c("Ve"))
))

testmod <- mxModel(
  "GREMLtest",
  mxData(observed = dat, type="raw"),
  mxMatrix(type = "Full", nrow = 1, ncol=1, free=T, values = 2, labels = "ve", lbound = 0.0001, name = "Ve"),
  mxMatrix("Iden",nrow=100,name="I",condenseSlots=T),
  mxAlgebra(I %x% Ve,name="V"),
  ge,
  gff,
  plan
)

testrun <- mxRun(testmod)

omxCheckCloseEnough(testrun$output$estimate[1],var(dat[,1]),epsilon=10^-5)
omxCheckCloseEnough(testrun$expectation$b,mean(dat[,1]),epsilon=10^-5)
omxCheckCloseEnough(testrun$expectation$bcov,var(dat[,1])/100,epsilon=10^-5)
omxCheckCloseEnough(testrun$output$standardErrors[1],sqrt((2*testrun$output$estimate^2)/100),epsilon=10^-3)

testrunsumm <- summary(testrun)
omxCheckEquals(testrunsumm$numObs,1)
omxCheckEquals(testrunsumm$estimatedParameters,2)
omxCheckEquals(testrunsumm$observedStatistics,100)
omxCheckEquals(testrunsumm$degreesOfFreedom,98)
#Check GREML-specific part of summary() output:
omxCheckEquals(testrunsumm$GREMLfixeff$name,"x")
omxCheckCloseEnough(testrunsumm$GREMLfixeff$coeff,mean(dat[,1]),epsilon=10^-5)
omxCheckCloseEnough(testrunsumm$GREMLfixeff$se,sqrt(var(dat[,1])/100),epsilon=10^-5)


gff2 <- mxFitFunctionGREML()

testmod2 <- mxModel(
  "GREMLtest",
  mxData(observed = dat, type="raw"),
  mxMatrix(type = "Full", nrow = 1, ncol=1, free=T, values = 2, labels = "ve", lbound = 0.0001, name = "Ve"),
  mxMatrix("Iden",nrow=100,name="I",condenseSlots=T),
  mxAlgebra(I %x% Ve,name="V"),
  ge,
  gff2
)

testrun2 <- mxRun(testmod2)

omxCheckCloseEnough(testrun2$output$estimate[1],var(dat[,1]),epsilon=10^-5)
omxCheckCloseEnough(testrun2$expectation$b,mean(dat[,1]),epsilon=10^-5)
omxCheckCloseEnough(testrun2$expectation$bcov,var(dat[,1])/100,epsilon=10^-5)

testrun2summ <- summary(testrun2)
omxCheckEquals(testrun2summ$numObs,1)
omxCheckEquals(testrun2summ$estimatedParameters,2)
omxCheckEquals(testrun2summ$observedStatistics,100)
omxCheckEquals(testrun2summ$degreesOfFreedom,98)
#Check GREML-specific part of summary() output:
omxCheckEquals(testrun2summ$GREMLfixeff$name,"x")
omxCheckCloseEnough(testrun2summ$GREMLfixeff$coeff,mean(dat[,1]),epsilon=10^-5)
omxCheckCloseEnough(testrun2summ$GREMLfixeff$se,sqrt(var(dat[,1])/100),epsilon=10^-5)

