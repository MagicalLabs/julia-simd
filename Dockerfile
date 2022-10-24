FROM julia:1.8.1

COPY deps.jl /usr/src/app/
RUN julia /usr/src/app/deps.jl

COPY simd_benchmark.jl /usr/src/app/

CMD ["julia", "/usr/src/app/simd_benchmark.jl"]
