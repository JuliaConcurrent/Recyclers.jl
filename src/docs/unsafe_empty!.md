    Recyclers.unsafe_empty!(recycler::AbstractRecycler) -> recycler
    Recyclers.unsafe_empty!(cache::AbstractCache) -> cache

Empty a `cache` or underlying cache of a `recycler` to help garbage collecting pooled
objects.  It is unsafe in the sense that there is no protection against accesses from other
tasks; i.e., the programmer calling this function is responsible for ensuring that no
concurrent tasks are accessing `recycler`.
