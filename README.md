# ExpressionCleanup

This package exports one function, `Cleanup[expr, func]` which will call `func` when all references to `expr` are gone. `Cleanup[expr]` will call any cleanup code that has been registered for `expr`, and `Cleanup[]` will call all registered cleanup code.  All cleanup code is called when the kernel exits cleanly.

I'm not sold on the name `Cleanup`.  Maybe `AddReleaseFunction` and `CallReleaseFunction`.

Note that 'references' includes anything in the output history, anything accessible via `%` or `Out[..]`.  In the example below, `$HistoryLength` is set to zero otherwise `Out[4]` would have kept the expression still available.



```
In[1]:= PacletDirectoryLoad[pathToGitCheckout];

In[2]:= << ExpressionCleanup`
(*library will be built if need be*)

In[3]:= $HistoryLength = 0

Out[3]= 0

In[4]:= f = {1, 2, 3}

Out[4]= {1, 2, 3}

In[5]:= Cleanup[f,
  Print["calling deletion code"];
  Print["use any compound expression"];
]

In[6]:= f =.

During evaluation of In[6]:= calling deletion code

During evaluation of In[6]:= use any compound expression
```
