Run:
- docker build . -t julia-simd:test
- docker run julia-simd:test

After this you'll see the following output:
slow test results: Trial(845.634 μs)
fast test results: Trial(182.495 μs)
