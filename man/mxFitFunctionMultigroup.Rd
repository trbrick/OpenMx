%
%   Copyright 2007-2015 The OpenMx Project
%
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
% 
%        http://www.apache.org/licenses/LICENSE-2.0
% 
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.

\name{mxFitFunctionMultigroup}
\alias{MxFitFunctionMultigroup-class}
\alias{mxFitFunctionMultigroup}

\title{Aggregate fit statistics from multiple submodels}

\description{
mxFitFunctionMultigroup creates a fit function consisting of the sum of the fit
statistics from a list of submodels provided. 

This is conceptually similar to creating an mxAlgebra consisting of the sum of 
the subModel objectives and also creating an algebra fit function to optimize the
model based on this aggregate value.

This call to mxFitFunctionMultigroup:

    \code{mxFitFunctionMultigroup(c("model1", "model2"))}

then, is almost equivalent to the following pair of statements:

    \code{mxAlgebra(model1.objective + model2.objective, name="myAlgebra")}

    \code{mxFitFunctionAlgebra("myAlgebra")}

In addition to being more compact and readable, using mxFitFunctionMultigroup has
additional side effects which are valuable for multi-group modeling.

Firstly, it aggregates analytic derivative calculations. Secondly, it allows \code{\link{mxRefModels}} 
to compute saturated models for raw data, as this function can learn which are the constituent submodels.

Note: You can refer to the algebra generated by mxFitFunctionMultigroup when used in a group "modelName"
as:

    \code{modelName.fitfunction}

}

\usage{
mxFitFunctionMultigroup(groups, ..., verbose = 0L)
}

\arguments{
\item{groups}{vector of fit function names (strings)}

\item{...}{Not used. Forces subsequent arguments to be specified by name.}

\item{verbose}{the level of debugging output}
}

\examples{
require("OpenMx")
mxFitFunctionMultigroup(c("model1", "model2")) # names of sub-models to be jointly optimised
}
