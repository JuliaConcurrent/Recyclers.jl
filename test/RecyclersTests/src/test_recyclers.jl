module TestRecyclers

using Random: rand!
using Recyclers
using Test

using ..Utils

function check_seq_untyped(R, factory)
    T = typeof(factory())
    recycler = R(factory)
    @test recycler isa R{T}
    check_seq(T, recycler)
end

function check_seq_typed(R, factory)
    T = typeof(factory())
    check_seq(T, R{T}(factory))
end

function check_seq(T, recycler)
    @test eltype(recycler) === T
    @test Recyclers.get!(recycler) isa T
    @test Recyclers.get!(recycler) isa T
    object = Recyclers.get!(recycler)
    @test Recyclers.recycle!(recycler, object)
    @test Recyclers.get!(recycler) === object
end

zeros3() = zeros(Int, 3)

function test_seq_untyped()
    @testset "$(nameof(R))" for R in Utils.recycler_types()
        check_seq_untyped(R, zeros3)
    end
end

function test_seq_typed()
    @testset "$(nameof(R))" for R in Utils.recycler_types()
        check_seq_typed(R, zeros3)
    end
end

function check_concurrency(recycler; ntrials = 2^10, ntasks = Threads.nthreads())
    failures = [Ref(0) for _ in 1:ntasks]
    @sync for fs in failures
        Threads.@spawn begin
            tmp = Recyclers.get!(recycler)
            for _ in 1:ntrials
                Recyclers.recycling!(recycler) do xs
                    rand!(tmp)
                    copyto!(xs, tmp)
                    rand(Bool) && yield()
                    fs[] += !isequal(xs, tmp)
                end
            end
        end
    end
    @test sum(getindex, failures) == 0
end

function test_concurrency(ntrials = 2^10)
    @testset "$(nameof(R))" for R in Utils.recycler_types()
        @testset for oversubscribe in [1, 3]
            check_concurrency(R(zeros3); ntasks = Threads.nthreads() * oversubscribe)
        end
    end
end

function test_reinit_sharded()
    @testset "$(nameof(R))" for R in Utils.recycler_types()
        recycler = R(zeros3)
        @test Recyclers.unsafe_destroy!(recycler) === recycler
        @test Recyclers.unsafe_init!(recycler) === recycler
        if recycler isa Recyclers.ShardedRecycler
            @test length(recycler.cache.pools) == Threads.nthreads()
        end
    end
end

end  # module
