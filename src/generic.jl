Base.eltype(::Type{<:AbstractCache{T}}) where {T} = T
Base.eltype(::Type{<:AbstractRecycler{T}}) where {T} = T

function Recyclers.get!(factory, cache::AbstractCache{T}) where {T}
    y = Recyclers.maybeget!(cache)
    if y === nothing
        return factory()::T
    else
        return something(y)::T
    end
end

Recyclers.get!(recycler::AbstractRecycler{T}) where {T} =
    Recyclers.get!(factoryof(recycler), cacheof(recycler))::T

Recyclers.recycle!(recycler::AbstractRecycler{T}, object::T) where {T} =
    Recyclers.recycle!(cacheof(recycler), object)

function Recyclers.recycling!(body, factory, cache::AbstractCache)
    object = Recyclers.get!(factory, cache)
    y = body(object)
    Recyclers.recycle!(cache, object)
    return y
end

function Recyclers.recycling!(body, recycler::AbstractRecycler)
    object = Recyclers.get!(recycler)
    y = body(object)
    Recyclers.recycle!(recycler, object)
    return y
end

# With element type
# (There's always a specialization)
#=
function (::Type{Cache})(objects; kwargs...) where {T,Cache<:AbstractCache{T}}
    cache = Cache(; kwargs...)
    for x in objects
        Recyclers.recycle!(cache, x) || break
    end
    return cache
end
=#

# No element type
function (::Type{Cache})(objects; kwargs...) where {Cache<:AbstractCache}
    if !(Base.IteratorEltype(objects) isa Base.HasEltype)
        objects = identity.(objects)
        isempty(objects) && error("`objects` collection has no eltype and is empty")
    end
    return Cache{eltype(objects)}(objects; kwargs...)
end

Recyclers.factoryof(recycler::AbstractRecycler) = recycler.factory
Recyclers.cacheof(recycler::AbstractRecycler) = recycler.cache
cachetypeof(::Type{Union{}}) = error("unreachable")

maybeeltype(::Type{<:AbstractRecycler}) = nothing
maybeeltype(::Type{<:AbstractRecycler{T}}) where {T} = T

function (::Type{Recycler})(factory; kwargs...) where {Recycler<:AbstractRecycler}
    Cache = cachetypeof(Recycler)
    T = maybeeltype(Recycler)
    if T === nothing
        object = factory()
        return Recycler(factory, Cache((object,); kwargs...))::Recycler
    else
        return Recycler(factory, Cache{T}(; kwargs...))::Recycler
    end
end

function Recyclers.unsafe_init!(recycler::AbstractRecycler)
    Recyclers.unsafe_init!(Recyclers.cacheof(recycler))
    return recycler
end

function Recyclers.unsafe_destroy!(recycler::AbstractRecycler)
    Recyclers.unsafe_destroy!(Recyclers.cacheof(recycler))
    return recycler
end

function Recyclers.unsafe_empty!(recycler::AbstractRecycler)
    Recyclers.unsafe_empty!(Recyclers.cacheof(recycler))
    return recycler
end
