    Recyclers.get!(recycler::AbstractRecycler{T}) -> object::T
    Recyclers.get!(factory, cache::AbstractCache{T}) -> object::T

Obtain cached `object` of type `T` or create a new one using `factory()`.

!!! warning
    The `factory` function must not introduce any concurrency problems. See see
    [`AbstractRecycler`](@ref) for more information.
