cachetypeof(::Type{<:CentralizedRecycler}) = CentralizedCache

# Workaround for avoid storing types as `DataType``
CentralizedRecycler(::Type{Factory}, cache::CentralizedCache{T}) where {Factory,T} =
    CentralizedRecycler{T,Type{Factory}}(Factory, cache)
CentralizedRecycler{T}(::Type{Factory}, cache::CentralizedCache{T}) where {Factory,T} =
    CentralizedRecycler{T,Type{Factory}}(Factory, cache)

CentralizedRecycler{T}(factory::Factory, cache::CentralizedCache{T}) where {Factory,T} =
    CentralizedRecycler{T,Factory}(factory, cache)

CentralizedCache{T}() where {T} = _CentralizedCache(T, nothing)

function CentralizedCache{T}(objects) where {T}
    node = nothing
    for x in objects
        node = StackNode{T}(x, node)
    end
    return _CentralizedCache(T, node)
end

function Recyclers.maybeget!(cache::CentralizedCache{T}) where {T}
    top = @atomic :acquire cache.top
    while true
        old = if top === nothing
            return nothing
        else
            top
        end::StackNode{T}
        next = old.next
        (top, success) = @atomicreplace :acquire_release :acquire cache.top old => next
        success && return Some{T}(old.object)
    end
end

function Recyclers.recycle!(cache::CentralizedCache{T}, object::T) where {T}
    new = StackNode{T}(object, nothing)
    top = @atomic :monotonic cache.top
    while true
        new.next = top
        (top, success) = @atomicreplace :acquire_release :acquire cache.top top => new
        success && return true
    end
end

function Base.empty!(cache::CentralizedCache)
    @atomic :release cache.top = nothing
    return cache
end

function Recyclers.unsafe_empty!(cache::CentralizedCache)
    @atomic :monotonic cache.top = nothing
    return cache
end

Recyclers.unsafe_destroy!(cache::CentralizedCache) = Recyclers.unsafe_empty!(cache)
Recyclers.unsafe_init!(cache::CentralizedCache) = Recyclers.unsafe_empty!(cache)
