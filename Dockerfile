FROM julia:1.8.1

COPY SIMDExtras.jl /usr/src/app/SIMDExtras.jl
COPY deps.jl /usr/src/app/
RUN julia /usr/src/app/deps.jl

COPY simd_benchmark.jl /usr/src/app/
COPY simd_extras_benchmark.jl /usr/src/app/

CMD julia /usr/src/app/simd_benchmark.jl; julia, julia /usr/src/app/simd_extras_benchmark.jl
