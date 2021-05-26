# Recyclers.jl

```@docs
Recyclers
```

## Constructors

```@docs
Recyclers.AbstractRecycler
Recyclers.ShardedRecycler
Recyclers.CentralizedRecycler
Recyclers.@global
Recyclers.AbstractCache
```

## Recycling objects

```@docs
Recyclers.get!
Recyclers.maybeget!
Recyclers.recycle!
Recyclers.recycling!
```

## Managing recyclers

```@docs
Recyclers.unsafe_empty!
Recyclers.unsafe_init!
Recyclers.unsafe_destroy!
```
