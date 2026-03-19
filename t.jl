using SparseArrays, SuiteSparseGraphBLAS, BenchmarkTools
using SparseMatricesCSR
using LinearAlgebra

include("csr_sparse_transpose.jl")
include("maketestmatrix.jl")

################################################################################
################################################################################
################################################################################

# How big should the matrix be? 
NREFINE = 6
# Turn this on to check that the matrices are correct.
check = false
# Set to true to benchmark GraphBLAS transpose, requires SuiteSparseGraphBLAS.jl.
GB = true

function testmatrix(matrix)
    @info "#############  Testing $matrix with NREFINE = $NREFINE  ##############"
    Ac = matrix(NREFINE) 

    M, N = size(Ac)
    @info "Matrix M = $M by N = $N, nnz = $(nnz(Ac)), sparsity = $(nnz(Ac) / M / M)"
    Ar = copy(sparsecsr(Ac))
    @show typeof(Ac), typeof(Ar)

    @info "Benchmarking copy+transpose CSC"
    @btime copy(transpose($Ac))    # native Julia transpose
    @info "Benchmarking copy+transpose CSR"
    @btime copy(transpose($Ar))    # native Julia transpose


    if GB
        Gc = GBMatrix(Ac) # GraphBLAS sparse CSC copy
        # setstorageorder!(Gc, ColMajor())
        gbset(Gc, :format, :bycol)
        Gr = GBMatrix(Ac) # GraphBLAS sparse CSR copy
        # setstorageorder!(Gr, RowMajor())
        gbset(Gr, :format, :byrow)
        @show typeof(Gc), typeof(Gr)
        if check
            @show norm(gbtranspose(Gc) - copy(transpose(Ac))) # check
            @show norm(gbtranspose(Gr) - copy(transpose(Ar))) # check
        end
        @info "Benchmarking gbtranspose CSC"
        @btime gbtranspose($Gc)      # GraphBLAS transpose
        @info "Benchmarking gbtranspose CSR"
        @btime gbtranspose($Gr)      # GraphBLAS transpose
    end




    C = sparsecsr(Ac)

    @info "Benchmarking csr_transpose "
    @btime csr_transpose($C)      # GraphBLAS transpose

    if check
        @show norm(csr_transpose(C) - copy(transpose(Ac))) # check
    end

    @info "Benchmarking csr_transpose_2 "
    @btime csr_transpose_2($C)      # GraphBLAS transpose

    if check
        @show norm(csr_transpose_2(C) - copy(transpose(Ac))) # check
    end
    nothing
end

for matrix in [diffusionmatrix, incidencematrix, adjacencymatrix]
    testmatrix(matrix)
end

nothing
