__precompile__()

module Monadics


export mbind, mreturn, mjoin, @monadic, ↣


function mbind end
function mreturn end
function mjoin end


macro monadic(x)
    eval(x)
    _dispatch_monadic(x)
end


function _dispatch_monadic(x::Expr)
    _dispatch_monadic(Val(x.head), x.args)
end


function _dispatch_monadic(s::Symbol)
    quote
        @inline mreturn(::Type{$s}, x) = $s(x)
        @inline mjoin(m::$s) = mbind(identity, m)
        @inline Base.map(f::Function, m::$s) =
            mbind(m) do x
                mreturn($s, f(x))
            end
        @inline ↣(m::$s, f::Function) = mbind(f, m)
    end
end


function _dispatch_monadic(::Val{:abstract}, s::Symbol)
    quote
        @inline mreturn(::Type{T}, x) where {T<:$s} = T(x)
        @inline mjoin(m::T) where {T<:$s} = mbind(identity, m)
        @inline Base.map(f::Function, m::T) where {T<:$s} =
            mbind(m) do x
                mreturn(T, f(x))
            end
        @inline ↣(m::T, f::Function) where {T<:$s} = mbind(f, m)
    end
end


function _dispatch_monadic(::Val{:struct}, args::Vector{Any})
    _dispatch_monadic(args[2])
end


function _dispatch_monadic(::Val{:mutable}, args::Vector{Any})
    _dispatch_monadic(args[2])
end


function _dispatch_monadic(::Val{:curly}, args::Vector{Any})
    _dispatch_monadic(args[1])
end


function _dispatch_monadic(::Val{:const}, args::Vector{Any})
    _dispatch_monadic(args[1])
end


function _dispatch_monadic(::Val{:abstract}, args::Vector{Any})
    _dispatch_monadic(Val(:abstract), args[1])
end


function _dispatch_monadic(::Val{:(=)}, args::Vector{Any})
    _dispatch_monadic(args[1])
end


@monadic const Optional{T} = Union{Nothing,T}
@monadic const Maybe{T} = Optional{Some{T}}

end # module
