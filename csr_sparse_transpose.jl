
@inbounds function realize_csr_transpose(IA, JA, VA, m, n)
    W = zeros(eltype(IA), n)
    for k in eachindex(JA)
        W[JA[k]] += 1
    end
    IAT = zeros(eltype(IA), n + 1)
    IAT[1] = 1
    for i in 1:n
        IAT[i+1] = IAT[i] + W[i]
    end
    W .= IAT[1:end-1]
    JAT = similar(JA)
    VAT = similar(VA)
    for k in 1:length(IA)-1
        for j in IA[k]:IA[k+1]-1
            ti = JA[j]
            p = W[ti]
            JAT[p] = k
            VAT[p] = VA[j]
            W[ti] += 1
        end
    end
    return IAT, JAT, VAT
end

function csr_transpose(A::SparseMatrixCSR)
    IAT, JAT, VAT = realize_csr_transpose(A.rowptr, A.colval, A.nzval, A.m, A.n)
    return SparseMatrixCSR{1}(A.n, A.m, IAT, JAT, VAT)
end

@inbounds function realize_csr_transpose_2(IA, JA, VA, m, n)
    IAT = zeros(eltype(IA), n + 1)
    for k in eachindex(JA)
        IAT[JA[k]+1] += 1
    end
    ps = view(IAT, 2:length(IAT))
    sum = 1
    for i in 1:n
        c = ps[i]
        ps[i] = sum
        sum += c
    end
    JAT = similar(JA)
    VAT = similar(VA)
    for k in 1:m
        for j in IA[k]:IA[k+1]-1
            ti = JA[j]
            p = ps[ti]
            JAT[p] = k
            VAT[p] = VA[j]
            ps[ti] += 1
        end
    end
    IAT[1] = 1
    return IAT, JAT, VAT
end

function csr_transpose_2(A::SparseMatrixCSR)
    IAT, JAT, VAT = realize_csr_transpose_2(A.rowptr, A.colval, A.nzval, A.m, A.n)
    return SparseMatrixCSR{1}(A.n, A.m, IAT, JAT, VAT)
end
