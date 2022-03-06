# Recyclers

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliaconcurrent.github.io/Recyclers.jl/dev)
[![CI](https://github.com/JuliaConcurrent/Recyclers.jl/actions/workflows/test.yml/badge.svg)](https://github.com/JuliaConcurrent/Recyclers.jl/actions/workflows/test.yml)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

Recyclers.jl is a set of tools for implementing memory reuse patterns in multi-tasking Julia
programs.

```julia
julia> using Recyclers

julia> recycler = Recyclers.CentralizedRecycler(() -> zeros(3));

julia> xs = Recyclers.get!(recycler)  # get a cached object or create a new one
3-element Vector{Float64}:
 0.0
 0.0
 0.0

julia> Recyclers.recycle!(recycler, xs)  # returns `true` if recycled
true
```
