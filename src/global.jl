# Define `Recyclers.@global`
macro _global(ex::Expr)
    if Meta.isexpr(ex, :(=), 2)
        lhs, rhs = ex.args
        if lhs isa Symbol
            assignment = :(const $(esc(lhs)) = $(esc(rhs)))
            init = :(Recyclers.unsafe_init!($(esc(lhs))))
            InitializerModule = esc(gensym(:InitializerModule))
            expr = quote
                module $InitializerModule
                function $(esc(:__init__)) end
                end  # module $InitializerModule
                $(esc(:_M)) = $InitializerModule
                $(Expr(:block, __source__, assignment))
                $InitializerModule.__init__() = $(Expr(:block, __source__, init))
            end
            return Expr(:toplevel, expr.args...)
        end
    end
    error("require an assignment to a symbol (global name)")
end
