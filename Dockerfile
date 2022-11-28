FROM julia:1.8.1

ADD biosim /usr/src/app/biosim/
COPY deps.jl /usr/src/app/deps.jl
RUN julia /usr/src/app/deps.jl

COPY simd_benchmark.jl /usr/src/app/
COPY simd_extras_benchmark.jl /usr/src/app/

CMD julia /usr/src/app/simd_benchmark.jl; julia, julia /usr/src/app/biosim/Biosim_v0.1.45/simd_extras_benchmark.jl