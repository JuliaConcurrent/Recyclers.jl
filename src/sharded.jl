cachetypeof(::Type{<:ShardedRecycler}) = ShardedCache

# Workaround for avoid storing types as `DataType``
ShardedRecycler(::Type{Factory}, cache::ShardedCache{T}) where {Factory,T} =
    ShardedRecycler{T,Type{Factory}}(Factory, cache)
ShardedRecycler{T}(::Type{Factory}, cache::ShardedCache{T}) where {Factory,T} =
    ShardedRecycler{T,Type{Factory}}(Factory, cache)

ShardedRecycler{T}(factory::Factory, cache::ShardedCache{T}) where {Factory,T} =
    ShardedRecycler{T,Factory}(factory, cache)

aslimit(limit::Integer) = convert(UInt, limit)
function aslimit(limit::Float64)
    isequal(limit, Inf) && return typemax(UInt)
    throw(ArgumentError("expected `Inf` or a positive integer"))
end

function ShardedCache{T}(; limit::Union{Integer,Float64} = 8) where {T}
    limit = aslimit(limit)
    pools = [T[] for _ in 1:Threads.nthreads()]
    return ShardedCache(limit, Val(T), pools)
end

function ShardedCache{T}(objects; kwargs...) where {T}
    cache = ShardedCache{T}(kwargs...)
    pools = cache.pools
    i = 1
    for x in objects
        push!(pools[i], x)
        length(pools[i]) == cache.limit && break
        i = i == length(pools) ? 1 : i + 1
    end
    return cache
end

function Recyclers.unsafe_init!(cache::ShardedCache)
    pools = cache.pools
    sizehint!(empty!(pools), Threads.nthreads())
    for _ in 1:Threads.nthreads()
        push!(pools, eltype(cache)[])
    end
    return cache
end

function Recyclers.maybeget!(cache::ShardedCache{T}) where {T}
    pool = cache.pools[Threads.threadid()]
    isempty(pool) && return nothing
    return Some{T}(pop!(pool))
end

function Recyclers.recycle!(cache::ShardedCache{T}, object::T) where {T}
    pool = cache.pools[Threads.threadid()]
    if length(pool) < cache.limit
        push!(pool, object)
        return true
    else
        return false
    end
end

function Recyclers.unsafe_empty!(cache::ShardedCache)
    foreach(empty!, cache.pools)
    return cache
end

function Recyclers.unsafe_destroy!(cache::ShardedCache)
    empty!(cache.pools)
    return cache
end
