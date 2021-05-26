const HAS_ATOMIC = VERSION ≥ v"1.7"

macro if_has_atomic(ex)
    if HAS_ATOMIC
        esc(ex)
    end
end

mutable struct StackNode{T}
    object::T
    next::Union{Nothing,StackNode{T}}
end

function _CentralizedCache end
