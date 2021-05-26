module TestGlobal

using Recyclers
using Test

Recyclers.@global RE1 = Recyclers.ShardedRecycler(() -> [1, 2, 3])
atexit() do
    Recyclers.unsafe_destroy!(RE1)
end

function test_init_sharded()
    @test length(RE1.cache.pools) == Threads.nthreads()
end

end  # module
