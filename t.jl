using SparseArrays, SuiteSparseGraphBLAS, BenchmarkTools
using SparseMatricesCSR
using LinearAlgebra

include("csr_sparse_transpose.jl")
include("maketestmatrix.jl")

################################################################################
################################################################################
################################################################################


Ac = diffusionmatrix(1) # sparse incidence matrix
# Ac = incidencematrix(5) # sparse incidence matrix
# Ac = adjacencymatrix(5) # sparse adjacency matrix
M, N = size(Ac)
@info "Matrix M = $M by N = $N, nnz = $(nnz(Ac)), sparsity = $(nnz(Ac) / M / M)"
Ar = copy(sparsecsr(Ac));
@show typeof(Ac), typeof(Ar)

check = false
GB = !false


@info "Benchmarking copy+transpose CSC"
@btime copy(transpose($Ac));    # native Julia transpose
@info "Benchmarking copy+transpose CSR"
@btime copy(transpose($Ar));    # native Julia transpose


if GB
    Gc = GBMatrix(Ac) # GraphBLAS sparse CSC copy
    # setstorageorder!(Gc, ColMajor())
    gbset(Gc, :format, :bycol)
    Gr = GBMatrix(copy(sparsecsr(Ac))) # GraphBLAS sparse CSR copy
    # setstorageorder!(Gr, RowMajor())
    gbset(Gr, :format, :byrow)
    @show typeof(Gc), typeof(Gr)
    if check
        @show norm(gbtranspose(Gc) - copy(transpose(Ac))) # check
        @show norm(gbtranspose(Gr) - copy(transpose(Ar))) # check
    end
    @info "Benchmarking gbtranspose CSC"
    @btime gbtranspose($Gc);      # GraphBLAS transpose
    @info "Benchmarking gbtranspose CSR"
    @btime gbtranspose($Gr);      # GraphBLAS transpose
end




C = sparsecsr(Ac)

@info "Benchmarking csr_transpose "
@btime csr_transpose($C);      # GraphBLAS transpose

if check
    @show norm(csr_transpose(C) - copy(transpose(Ac))) # check
end

@info "Benchmarking csr_transpose_2 "
@btime csr_transpose_2($C);      # GraphBLAS transpose

if check
    @show norm(csr_transpose_2(C) - copy(transpose(Ac))) # check
end

nothing
