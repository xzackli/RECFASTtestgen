
include("deps/deps.jl")

"""
Wrapper of RECFAST Fortran code with parameters as defined in that code.
Returns tuple of (z's, xe's)
"""
function get_xe(OmegaB::Float64, OmegaC::Float64, OmegaL::Float64,
                HOinp::Float64, Tnow::Float64, Yp::Float64;
                Hswitch::Int64=1, Heswitch::Int64=6,
                Nz::Int64=1000, zstart::Float64=10000., zend::Float64=0.)

    xe = Array{Float64}(undef,Nz)
    ccall(
        (:get_xe_, librecfast), Nothing,
        (Ref{Float64}, Ref{Float64}, Ref{Float64}, Ref{Float64}, Ref{Float64}, Ref{Float64},
         Ref{Int64}, Ref{Int64}, Ref{Int64}, Ref{Float64}, Ref{Float64}, Ref{Float64}),
        OmegaB, OmegaC, OmegaL, HOinp, Tnow, Yp, Hswitch, Heswitch, Nz, zstart, zend, xe
    )
    range(zstart,stop=zend,length=Nz+1)[2:end], xe
end



function get_init(z)
    x_H0, x_He0, x0 = [0.0], [0.0], [0.0]
    ccall(
        (:get_init_, librecfast), Nothing,
        (Ref{Float64}, Ref{Float64}, Ref{Float64}, Ref{Float64}),
        z, x_H0, x_He0, x0
    )
    return x_H0[1], x_He0[1], x0[1]
end


#                OmegaB  OmegaC  OmegaL  H0inp  Tnow  Yp
z, xedat = get_xe(0.046, 0.224,  0.73,   70.,  2.725, 0.24)

open("test_recfast_1.dat", "w") do io
    write(io, "# z Xe \n")
    for i in 1:length(xedat)
        write(io, "$(z[i]), $(xedat[i]) \n")
    end
end
