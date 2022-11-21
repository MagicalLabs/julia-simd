"""
This script defines a function to benchmark the SIMDExtras.jl package.

This package is available on Biosim's OVH1 machine (135.148.103.104).
The path to the package is /biosim/Biosim_v0.1.45/SIMDExtras.jl.

This path can be added to the environment variable JULIA_LOAD_PATH,
and then the script should run normally.
"""

using Pkg
using SIMD
using SIMDExtras
using Random
using BenchmarkTools
using Base.Cartesian: @nexprs

Random.seed!(0);

n = 1000000;
x = rand(Float32, n);

# The value of R determines the amount of COMPUTE work to be done.
# R needs to be large enough to make sure that the program is not memory-bound.
@generated function compute_load(x, ::Val{R}) where R
    quote
        n = length(x)
        lane = VecRange{8}(0)
        s = 0
        @inbounds @fastmath for i in 1:8:n-8
            a = x[i + lane]
            b = x[i + 8 + lane]
            s += hsum(hadd(a, b))

            @nexprs $R k -> begin
                r = @simd_extras a < b + 0.01 * k
                s += hsum(blendv(a, b, movemask(r)))
            end
        end
        return s
    end
end

compute_load(x, Val(1));

# We can see that the computation is not memory bound for R > 5
# Numbers are on Hayk's machine.

# 0.231398 ms
@benchmark compute_load($x, $(Val(0)))
@btime compute_load($x, $(Val(0)))

# 1.355 ms
@benchmark compute_load($x, $(Val(5)))
@btime compute_load($x, $(Val(5)))

# 2.078 ms
@benchmark compute_load($x, $(Val(10)))
@btime compute_load($x, $(Val(10)))