    Recyclers.recycle!(recycler::AbstractRecycler{T}), object::T) -> isrecycled::Bool
    Recyclers.recycle!(cache::AbstractCache{T}), object::T) -> isrecycled::Bool

Try to recycle a `object` and return `true` if and only if the `object` is recycled.
