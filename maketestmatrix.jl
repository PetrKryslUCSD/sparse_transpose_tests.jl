using FinEtools

function mesh(nrefine = 2)
    R = 1.0
    fens, fes = H8sphere(R, nrefine)
    return fens, fes
end

function diffusionmatrix(nrefine = 2)
    fens, fes = mesh(nrefine)
    femm = FEMMBase(IntegDomain(fes, GaussRule(3, 2)))
    geom = NodalField(fens.xyz)
    u = NodalField(zeros(count(fens), 1))
    numberdofs!(u)
    return bilform_diffusion(femm, geom, u, DataCache(1.0))
end

function adjacencymatrix(nrefine = 2)
    fens, fes = mesh(nrefine)
    femm = FEMMBase(IntegDomain(fes, GaussRule(3, 2)))
    return connectionmatrix(femm, count(fens))
end

function incidencematrix(nrefine = 2)
    fens, fes = mesh(nrefine)
    I = zeros(eltype(fes.conn[1]), nodesperelem(fes) * count(fes))
    J = similar(I)
    V = similar(I)
    p = 1
    for i in eachindex(fes)
        for j in 1:nodesperelem(fes)
            I[p] = i
            J[p] = fes.conn[i][j]
            V[p] = 1
            p += 1
        end
    end
    return sparse(I, J, V, count(fes), count(fens))
end