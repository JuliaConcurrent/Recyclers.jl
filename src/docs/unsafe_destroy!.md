    Recyclers.unsafe_destroy!(recycler::AbstractRecycler) -> recycler
    Recyclers.unsafe_destroy!(cache::AbstractCache) -> cache

Destroy a `cache` or underlying cache of a `recycler`, typically to minimize serialized
global cache.  The `cache` and `recycler` cannot be used unless
[`Recyclers.unsafe_init!`](@ref) is called first.  It is unsafe in the sense that there is
no protection against accesses from other tasks; i.e., the programmer calling this function
is responsible for ensuring that no concurrent tasks are accessing `recycler`.
