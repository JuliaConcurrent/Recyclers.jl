# Recyclers

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
