(* ::Package:: *)

BeginPackage["ExpressionCleanup`"]

Cleanup::usage = "Cleanup[expr, func] evaluates func when there are no more references to expr in a Wolfram Language session."


Begin["`Private`"]



(* ::Section::Closed:: *)
(*Find library, build if necessary*)


buildLibrary[] := (
	Needs["CCompilerDriver`"];
	Module[
		{
			parentDirectory = ParentDirectory @ DirectoryName[$InputFileName],
			source = PacletManager`PacletResource["ExpressionCleanup","ExpressionCleanup.cpp"],
			libDirectory
		},
		libDirectory = FileNameJoin[{parentDirectory, "LibraryResources", $SystemID}];
		If[!DirectoryQ[libDirectory]
			,
			CreateDirectory @ libDirectory
		];
		PrintTemporary["building library"];
		CCompilerDriver`CreateLibrary[ {source}, "ExpressionCleanup", "TargetDirectory" -> libDirectory, "Language" -> "C++"]
	]
)

$Initialized = Or[
	StringQ[$library = FindLibrary["ExpressionCleanup"]],
	StringQ[$library = buildLibrary[]]
] 


(* ::Section::Closed:: *)
(*Main functions*)


Quiet[LibraryUnload[$library]];

(*not used, but we must export a function for CreateManagedLibraryExpression to work*)
deleteFunction = LibraryFunctionLoad[$library, "deleteInstance", {Integer}, Integer]




$cache = <| |>
$store = Language`NewExpressionStore["ExpressionCleanup"];

Attributes[Cleanup] = {HoldAll}

Cleanup[expr_, func_] /; $Initialized := Module[
	{
		mle = CreateManagedLibraryExpression["ExpressionCleanup", ExpressionCleanup]
	},
	$store["put"[expr, 0, mle]];
	$cache[ManagedLibraryExpressionID[mle]] := func;
]

Cleanup[expr_] := ($store["remove"[expr]];)

Cleanup[] := (Map[
	$store["remove"[#]]&,
	$store["listTable"[]][[All, 1]]
];)


iCleanup[id_] := (
	$cache[id];
	KeyDropFrom[$cache, id];
)


End[]
EndPackage[]
