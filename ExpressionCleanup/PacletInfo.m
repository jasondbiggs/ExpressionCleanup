(* ::Package:: *)

(* Paclet Info File *)

Paclet[
    Name -> "ExpressionCleanup",
    Description -> "A tool for automatic cleanup when expressions go out of scope.",
    Version -> "0.0.1",
    MathematicaVersion -> "12.0+",
    Loading -> Manual,
    Updating -> Automatic,
    Extensions -> {
        {"LibraryLink"},
        {
        	"Resource",
        	Root -> "Resources",
        	Resources -> {"ExpressionCleanup.cpp"}
        },
        {
            "Kernel",
            Root->"Kernel",
            Context->{"ExpressionCleanup`"},
            Symbols -> 
            		{
					"ExpressionCleanup`Cleanup"
				}
            
		}
	}
]

