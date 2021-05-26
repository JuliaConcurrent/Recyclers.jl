    AbstractRecycler{T}

A high-level object recycling interface.  It pairs an [`AbstractCache{T}`](@ref
Recyclers.AbstractCache) with an object `factory` function.

A concrete subtype `Recycler{T}` of `AbstractRecycler{T}` (e.g., [`ShardedRecycler`](@ref))
have the following constructor methods:

    Recycler{T}(factory)
    Recycler(factory)

where `factory` is a zero-argument function that returns an object of type `T` and `objects`
is an iterable with elements of type `T`.  The constructor of each `Recycler` subtype may
accept additional keyword arguments.

**`factory` function contracts**.  The program author calling `Recycler` constructor must
verify that invocation of `factory` function on arbitrary worker thread does not introduce
any concurrency problems including data races.  When used with the method
`Recycler{T}(factory)`, the `factory` function must return an object of type `T` (where `T`
does not have to be concrete; i.e., `T = Any` always works).  A run-time error is thrown if
`factory` is called and return an object that is not of type `T`.  When used with the method
`Recycler(factory)`, the `factory` function must be type-stable in the sense that objects
`o1 = factory()` and `o2 = factory()` obtained in arbitrary calling contexts must satisfy
`typeof(o1) === typeof(o2)`.  With any constructor methods, changes in the return type of
`factory` function after construction of the recycler may result in run-time error.

Supported methods:

* [`Recyclers.get!(recycler)`](@ref Recyclers.get!)
* [`Recyclers.maybeget!(recycler)`](@ref Recyclers.maybeget!)
* [`Recyclers.recycle!(recycler, object)`](@ref Recyclers.recycle!)
* [`Recyclers.recycling!(body, recycler)`](@ref Recyclers.recycling!)
* [`Recyclers.unsafe_empty!(recycler)`](@ref Recyclers.unsafe_empty!)
