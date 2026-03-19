julia> include("t.jl")
[ Info: Matrix M = 2000133 by N = 2000133, sparsity = 1.0e-6
ERROR: LoadError: ReadOnlyMemoryError()
Stacktrace:
  [1] _setindex!
    @ .\array.jl:991 [inlined]
  [2] setindex!
    @ .\array.jl:986 [inlined]
  [3] copyto_unaliased!(deststyle::IndexLinear, dest::Matrix{Float64}, srcstyle::IndexCartesian, src::SparseMatrixCSR{1, Float64, Int64})
    @ Base .\abstractarray.jl:1096
  [4] copyto!
    @ .\abstractarray.jl:1070 [inlined]
  [5] GBMatrix{Float64, Float64}(A::SparseMatrixCSR{1, Float64, Int64}; fill::Float64)
    @ SuiteSparseGraphBLAS C:\Users\pkonl\VSCode_Julia_portable\assets\.julia-1.12.4-depot\packages\SuiteSparseGraphBLAS\A4fmM\src\types.jl:511
  [6] GBMatrix
    @ C:\Users\pkonl\VSCode_Julia_portable\assets\.julia-1.12.4-depot\packages\SuiteSparseGraphBLAS\A4fmM\src\types.jl:505 [inlined]
  [7] GBMatrix(A::SparseMatrixCSR{1, Float64, Int64})
    @ SuiteSparseGraphBLAS C:\Users\pkonl\VSCode_Julia_portable\assets\.julia-1.12.4-depot\packages\SuiteSparseGraphBLAS\A4fmM\src\types.jl:519
  [8] top-level scope
    @ C:\Users\pkonl\Documents\zzWIP\sparse_transpose_tests.jl\t.jl:21
  [9] include(mapexpr::Function, mod::Module, _path::String)
    @ Base .\Base.jl:307
 [10] top-level scope
    @ REPL[1]:1
in expression starting at C:\Users\pkonl\Documents\zzWIP\sparse_transpose_tests.jl\t.jl:21

julia> versioninfo()
Julia Version 1.12.4
Commit 01a2eadb04 (2026-01-06 16:56 UTC)
Build Info:
  Official https://julialang.org release
Platform Info:
  OS: Windows (x86_64-w64-mingw32)
  CPU: 12 × 12th Gen Intel(R) Core(TM) i7-1265U
  WORD_SIZE: 64
  LLVM: libLLVM-18.1.7 (ORCJIT, alderlake)
  GC: Built with stock GC
Threads: 1 default, 1 interactive, 1 GC (on 12 virtual cores)
Environment:
  JULIA_DEPOT_PATH = C:/Users/pkonl/VSCode_Julia_portable/assets/.julia-1.12.4-depot


There is something very wrong with this way of creating the test matrix:
Gr = GBMatrix(copy(sparsecsr(Ac))); # GraphBLAS sparse CSR copy
# setstorageorder!(Gr, RowMajor())
gbset(Gr, :format, :byrow)