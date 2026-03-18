using SparseArrays, SuiteSparseGraphBLAS, BenchmarkTools
using SparseMatricesCSR
using LinearAlgebra

include("csr_sparse_transpose.jl")

################################################################################
################################################################################
################################################################################
M = 2 * 100_000 + 133
N = M
sparsity = 10  / M

Ac = sprand(M, N, sparsity);
@info "Matrix M = $M by N = $N, sparsity = $sparsity, nnz = $(nnz(Ac))"
Ar = sparsecsr(Ac);

check = false

Gc = GBMatrix(Ac); # GraphBLAS sparse CSC copy
Gr = GBMatrix(sparsecsr(Ac)); # GraphBLAS sparse CSR copy

if check
    @show norm(gbtranspose(Gc) - copy(transpose(Ac))) # check
end

@info "Benchmarking copy+transpose CSC"
@btime copy(transpose($Ac));    # native Julia transpose
@info "Benchmarking copy+transpose CSR"
@btime copy(transpose($Ar));    # native Julia transpose


@info "Benchmarking gbtranspose CSC"
@btime gbtranspose($Gc);      # GraphBLAS transpose
@info "Benchmarking gbtranspose CSR"
@btime gbtranspose($Gr);      # GraphBLAS transpose

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