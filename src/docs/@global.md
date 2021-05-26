    Recyclers.@global recycler_name = make_recycler

Declare a global constant named `recycler_name` (a symbol) which holds a recycler created by
`make_recycler` (an expression).

The recycler is re-initialized (using [`Recyclers.unsafe_init!`](@ref)) while importing the
package in which `recycler_name` is defined.

If it can be ensured that no tasks are requiring to access `recycler_name` during exit,
it may be a good idea to call [`Recyclers.unsafe_destroy!`](@ref) or
[`Recyclers.unsafe_empty!`](@ref)  via `atexit`.

Example:

```JULIA
Recyclers.@global INTS_RECYCLER = Recyclers.ShardedRecycler(() -> Vector{Int}(undef, 100))
atexit() do
    Recyclers.unsafe_destroy!(INTS_RECYCLER)
end
```
