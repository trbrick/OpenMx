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

\name{omxApply}
\alias{omxApply}

\title{On-Demand Parallel Apply}

\description{
   If the snowfall library is loaded, then this function calls \code{\link[snowfall]{sfApply}}.  Otherwise it invokes \code{\link{apply}}.
}

\usage{
omxApply(x, margin, fun, ...)
}

\arguments{
   \item{x}{a vector (atomic or list) or an expressions vector. Other objects (including classed objects) will be coerced by \code{\link{as.list}}.}
   \item{margin}{a vector giving the subscripts which the function will be applied over.}
   \item{fun}{the function to be applied to each element of \code{x}.}
   \item{...}{optional arguments to \code{fun}.}
}

\seealso{
\code{\link{omxLapply}}, \code{\link{omxSapply}} 
}

\examples{

x <- cbind(x1 = 3, x2 = c(4:1, 2:5))
dimnames(x)[[1]] <- letters[1:8]
omxApply(x, 2, mean, trim = .2)

}
