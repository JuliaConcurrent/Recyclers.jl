    Recyclers.CentralizedRecycler{T}(factory)
    Recyclers.CentralizedRecycler(factory)

Create a centralized object recycler.  See [`AbstractRecycler`](@ref) for more information
on the constructor and supported methods.

!!! warning
    The `factory` function must not introduce any concurrency problems. See see
    [`AbstractRecycler`](@ref) for more information.

`CentralizedRecycler` uses a lock-free unbounded stack.  It supports thread-safe
`empty!(recycler)` method.
