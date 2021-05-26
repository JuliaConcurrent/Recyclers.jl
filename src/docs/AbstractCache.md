    AbstractCache{T}

A low-level object recycling interface.

Supported methods:

* [`Recyclers.get!(factory, cache)`](@ref Recyclers.get!)
* [`Recyclers.maybeget!(cache)`](@ref Recyclers.maybeget!)
* [`Recyclers.recycle!(cache, object)`](@ref Recyclers.recycle!)
* [`Recyclers.recycling!(body, factory, cache)`](@ref Recyclers.recycling!)
* [`Recyclers.unsafe_empty!(cache)`](@ref Recyclers.unsafe_empty!)

See also: [`AbstractRecycler`](@ref)
