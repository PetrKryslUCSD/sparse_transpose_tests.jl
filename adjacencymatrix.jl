using FinEtools

function adjacencymatrix(nrefine = 2)
    R = 1.0
    fens, fes = H8sphere(R, nrefine)
    femm = FEMMBase(IntegDomain(fes, GaussRule(3, 2)))
    A = connectionmatrix(femm, count(fens))
    return A
end