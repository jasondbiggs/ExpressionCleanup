
#include "mathlink.h"
#include "WolframLibrary.h"

#include <cstdlib>


void callCleanupFunction(WolframLibraryData libData, mint wlid) {
	MLINK link = libData->getMathLink(libData);
	MLPutFunction(link, "EvaluatePacket", 1);
		MLPutFunction(link, "ExpressionCleanup`Private`iCleanup", 1);
			MLPutInteger(link, wlid);
	libData->processMathLink(link);
	int pkt = MLNextPacket(link);
	if (pkt == RETURNPKT) {
		MLNewPacket(link);
	}
}

extern "C" DLLEXPORT int deleteInstance(WolframLibraryData libData, mint Argc, MArgument * Args, MArgument Res) {
	mint id = MArgument_getInteger(Args[0]);
	if(!id) {
		return LIBRARY_FUNCTION_ERROR;
	}
	return (*libData->releaseManagedLibraryExpression)("ExpressionCleanup", id);
}


DLLEXPORT void manage_ExpressionCleanup(WolframLibraryData libData, mbool mode, mint id)
{
	if (mode == 0) { // create
	} else { // destroy
		callCleanupFunction(libData, id );
	}
}


/* Initialize Library */
EXTERN_C DLLEXPORT int WolframLibrary_initialize( WolframLibraryData libData) {
	return (*libData->registerLibraryExpressionManager)("ExpressionCleanup", &manage_ExpressionCleanup);
}

/* Uninitialize Library */
EXTERN_C DLLEXPORT void WolframLibrary_uninitialize( WolframLibraryData libData) {
	int err = (*libData->unregisterLibraryExpressionManager)("ExpressionCleanup");
}

EXTERN_C DLLEXPORT mint WolframLibrary_getVersion() {
	return WolframLibraryVersion;
}
