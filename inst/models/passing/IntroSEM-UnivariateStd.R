# ---------------------------------------------------------------------
# Program: UnivariateStd-OpenMx100214.R
#  Author: Steven M. Boker
#    Date: Sun Feb 14 12:13:20 EST 2010
#
# This program fits a univariate model to the multiData simulated data.
#
#
# ---------------------------------------------------------------------
# Revision History
#    -- Sun Feb 14 12:13:16 EST 2010
#      Created UnivariateStd-OpenMx100214.R.
#
# ---------------------------------------------------------------------

# ----------------------------------
# Read libraries and set options.

require(OpenMx)

# ----------------------------------
# Read the data and print descriptive statistics.

data(multiData1)

# ----------------------------------
# Build an OpenMx univariate regression model using y and x1

manifests <- c("x1", "y")
multiData1Cov <- cov(multiData1[,c(1,5)])

uniRegModel <- mxModel("Univariate Regression of y on x1",
    type="RAM",
    manifestVars=manifests,
    mxPath(from="x1", to="y", arrows=1, 
           free=TRUE, values=.2, labels="b1"),
    mxPath(from=manifests, arrows=2, 
           free=TRUE, values=.8, labels=c("VarX1", "VarE")),
    mxData(observed=multiData1Cov, type="cov", numObs=500)
    )

uniRegModelOut <- mxRun(uniRegModel, suppressWarnings=TRUE)

summary(uniRegModelOut)

#---------------------
# check values: uniRegModelOut

expectVal <- c(0.669178, 1.138707, 1.650931)

expectSE <-c(0.053902, 0.07209, 0.104518)

expectMin <- 1312.985

omxCheckCloseEnough(expectVal, uniRegModelOut$output$estimate, 0.001)

omxCheckCloseEnough(expectSE, 
    as.vector(uniRegModelOut$output$standardError), 0.001)

omxCheckCloseEnough(expectMin, uniRegModelOut$output$minimum, 0.001)

omxCheckEquals(uniRegModelOut$output$fitUnits, "-2lnL")

