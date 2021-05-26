    Recyclers.recycle!(body, recycler::AbstractRecycler{T})) -> result
    Recyclers.recycle!(body, factory, cache::AbstractCache{T})) -> result

Call a single-argument function `body` with a `object`, try to recycle the `object`, and then
return the `result` returned from `body`.

The `object` is not recycled if `body` throws since the invariance of `object` may not hold
any more.
