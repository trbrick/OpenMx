/*
 *  Copyright 2007-2017 The OpenMx Project
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#include "glue.h"
#include "Compute.h"
#include "omxRFitFunction.h"
#include "EnableWarnings.h"

void omxRFitFunction::compute(int want, FitContext *)
{
	auto *oo = this;
	if (want & (FF_COMPUTE_INITIAL_FIT | FF_COMPUTE_PREOPTIMIZE)) return;

	omxRFitFunction* rFitFunction = this;

	SEXP theCall, theReturn;
	ScopedProtect p2(theCall, Rf_allocVector(LANGSXP, 3));
	SETCAR(theCall, rFitFunction->fitfun);
	SETCADR(theCall, rFitFunction->model);
	SETCADDR(theCall, rFitFunction->state);

	{
		ScopedProtect p1(theReturn, Rf_eval(theCall, R_GlobalEnv));

	if (LENGTH(theReturn) < 1) {
		// seems impossible, but report it if it happens
		omxRaiseErrorf("FitFunction returned nothing");
	} else if (LENGTH(theReturn) == 1) {
		oo->matrix->data[0] = Rf_asReal(theReturn);
	} else if (LENGTH(theReturn) == 2) {
		oo->matrix->data[0] = Rf_asReal(VECTOR_ELT(theReturn, 0));
		R_Reprotect(rFitFunction->state = VECTOR_ELT(theReturn, 1), rFitFunction->stateIndex);
	} else if (LENGTH(theReturn) > 2) {
		omxRaiseErrorf("FitFunction returned more than 2 arguments");
	}
	}
}

omxFitFunction *omxInitRFitFunction()
{ return new omxRFitFunction; }

void omxRFitFunction::init()
{
	FitContext::setRFitFunction(this);

	if(OMX_DEBUG) { mxLog("Initializing R fit function."); }
	omxRFitFunction *newObj = this;
	
	
	{
		SEXP newptr;
		ScopedProtect p1(newptr, R_do_slot(rObj, Rf_install("units")));
		setUnitsFromName(CHAR(STRING_ELT(newptr, 0)));
	}

	Rf_protect(newObj->fitfun = R_do_slot(rObj, Rf_install("fitfun")));
	R_ProtectWithIndex(newObj->model = R_do_slot(rObj, Rf_install("model")), &(newObj->modelIndex));
	Rf_protect(newObj->flatModel = R_do_slot(rObj, Rf_install("flatModel")));
	R_ProtectWithIndex(newObj->state = R_do_slot(rObj, Rf_install("state")), &(newObj->stateIndex));
}


