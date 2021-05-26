    Recyclers.maybeget!(recycler::AbstractRecycler{T}) -> Some{T}(object) or nothing
    Recyclers.maybeget!(cache::AbstractCache{T}) -> Some{T}(object) or nothing

Obtain cached `object` wrapped in a `Some{T}` or `nothing`.
