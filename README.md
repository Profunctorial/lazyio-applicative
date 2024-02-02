# lazyio-applicative

IO in Haskell is strict in order to preserve order of side effects due to laziness. This has the unfortunate side effect of taking away asymptotic performance from applicative io mappings due to no longer being able to incrementally/lazily produce structures. A concrete example would be using guarded recursion to incrementally/lazily produce a list of which it's elements are resultant of IO actions. 

## Assumptions 
- IO actions lifted into LazyIO are commutative up to correctness (explained below). 
- Safe mutli-threaded use is left to the programmer. LazyIO actions may share mutable resources and be run in parallel so 'commutative' here implies if `x op y = correct` then `y op x = correct`. 
- IO actions can be run in parallel and safe sharing of resources is up to the programmer 

## Details
`unsafeInterleaveIO` guarantees no work is repeated across threads (through `unsafeDupableInterleaveIO`).
The aformentioned function is also idempotent.
