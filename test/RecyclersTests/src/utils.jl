module Utils

using Recyclers

function recycler_types()
    ts = Any[Recyclers.ShardedRecycler]
    t = try
        Recyclers.CentralizedRecycler
    catch
        nothing
    end
    t === nothing || push!(ts, t)
    return ts
end

function cache_types()
    ts = Any[Recyclers.ShardedCache]
    t = try
        Recyclers.CentralizedCache
    catch
        nothing
    end
    t === nothing || push!(ts, t)
    return ts
end

end  # module
