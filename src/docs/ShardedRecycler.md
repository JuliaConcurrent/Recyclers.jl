    Recyclers.ShardedRecycler{T}(factory; [limit])
    Recyclers.ShardedRecycler(factory; [limit])

Create a sharded object recycler.  See [`AbstractRecycler`](@ref) for more information on
the constructor and supported methods.

!!! warning
    The `factory` function must not introduce any concurrency problems. See see
    [`AbstractRecycler`](@ref) for more information.

`ShardedRecycler` uses a stack of size bounded by `limit` for each worker thread.  The
keyword argument `limit` must be a positive integer less than `typemax(UInt)` or `Inf`.
