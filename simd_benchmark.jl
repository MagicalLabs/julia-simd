using Pkg
Pkg.add(["SIMD", "BenchmarkTools", "Random"])
using SIMD, Random, BenchmarkTools


Random.seed!(0);

n = 1000000;

function compute_load(n)
    s = Float32(0)
    @fastmath for i in 1:n
        j = Float32(i)
        s += sqrt(j)
    end
    return s
end

function compute_load_simd(n)
    s = Vec{8,Float32}(0)
    lane = Vec{8,Float32}(0:7 |> Tuple)
    @fastmath for i in 1:8:n
        j = lane + i
        s += sqrt(j)
    end
    return sum(s)
end

slow = @benchmark compute_load($n)
print("slow test results: ", slow)

# On Hayk's machine this is 4x faster.
fast = @benchmark compute_load_simd($n)
print("\nfast test results: ", fast)
print("\n")