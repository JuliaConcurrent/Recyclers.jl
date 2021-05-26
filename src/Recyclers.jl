baremodule Recyclers

###
### Generic API functions and types
###

function get! end
function maybeget! end

function recycle! end
function recycling! end

function unsafe_empty! end

function unsafe_init! end
function unsafe_destroy! end

abstract type AbstractCache{T} end
abstract type AbstractRecycler{T} end

function cacheof end
function factoryof end

function var"@global" end

"""
    InternalPrelude

Internal module. Define types and utilities just enough for defining public types.
"""
module InternalPrelude
using ..Recyclers: @global
const var"@_global" = var"@global"
include("prelude.jl")
end  # module InternalPrelude

###
### Concrete public types
###

struct ShardedCache{T} <: AbstractCache{T}
    limit::UInt
    eltype::InternalPrelude.Val{T}
    pools::InternalPrelude.Vector{InternalPrelude.Vector{T}}  # TODO: blocked stack?
end

struct ShardedRecycler{T,Factory} <: AbstractRecycler{T}
    factory::Factory
    cache::ShardedCache{T}
end

InternalPrelude.@if_has_atomic begin
    mutable struct CentralizedCache{T} <: AbstractCache{T}
        # pad?
        InternalPrelude.@atomic top::Union{Nothing,InternalPrelude.StackNode{T}}
        # cache::shardedCache{StackNode{T}}

        InternalPrelude._CentralizedCache(
            ::Type{T},
            top::Union{Nothing,InternalPrelude.StackNode{T}},
        ) where {T} = new{T}(top)
    end

    struct CentralizedRecycler{T,Factory} <: AbstractRecycler{T}
        factory::Factory
        cache::CentralizedCache{T}
    end
end

"""
    Internal

Internal module that contains main implementations.
"""
module Internal

using ..Recyclers: AbstractCache, AbstractRecycler, Recyclers, cacheof, factoryof
using ..InternalPrelude: HAS_ATOMIC, StackNode, _CentralizedCache

import ..InternalPrelude: @_global
import ..Recyclers: ShardedCache, ShardedRecycler
if HAS_ATOMIC
    import ..Recyclers: CentralizedCache, CentralizedRecycler
end

include("utils.jl")
include("generic.jl")
include("sharded.jl")
include("global.jl")

if HAS_ATOMIC
    include("centralized.jl")
end

end  # module Internal

# Something like this could be useful?
#
#     if InternalPrelude.HAS_ATOMIC
#         const Cache = CentralizedCache
#         const Recycler = CentralizedRecycler
#     else
#         const Cache = ShardedCache
#         const Recycler = ShardedRecycler
#     end
#
# But it will be problematic if people rely on `Cache(; limit = ...)` etc. OTOH,
# using a factory or abstract class for `Recycler` is not great since it's hard
# to use concrete recycler type on field or element type. Maybe a better
# midground is to define `default_recycler_type` or something to return a
# default recommended type. It's more apparent that the users have to call the
# common API.

Internal.define_docstrings()

end  # baremodule Recyclers
