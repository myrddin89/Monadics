---
syntax: julia
---

# Monadics

This packages provides a simple implementation of the [Monad](https://https://en.wikipedia.org/wiki/Monad_%28functional_programming%29)
typeclass for Julia. The aim of this package is to provide a common background
for working with high level abstractions in Julia, with a
generic interface which can adapt well to the type system.

**I reckon this package's state to be very preliminary and
subject to breaking changes in any moment.**

Contributions and ideas are welcome.
See the [Contributing](#contributing) section.

## The Maybe monad

The basic idea for the `Maybe` monad is that I
did not want to introduce a new `struct`, but instead I
chose to just define in a consistent way the method
definition required to represent the monadic structure. In
the case of `Maybe`, the type is defined in the standard
Julian way:

```julia
Maybe{T} = Union{Nothing,Some{T}}
```
and then it is possible to operate on a Maybe instance with
the usual functions: `mreturn`, `mjoin`, `mbind`.

The `mbind` function can be called with the infix operator
`↣`, which can be typed in the REPL as `\rightarrowtail`. It
would be possible to use `>>=` but it already has a meaning
in the  Julia language.

## Defining new monads

The package exports the macro `@monadic` which can help the
definition of a new monad. For example, to make the type
`MyMonad` monadic, it is sufficient to prepend to the struct
definition `@monadic` and the macro will take care to
correctly define all the methods required.
You only have to provide a definition for the `mbind`
function for your type, as shown in the code below.

```julia
@monadic struct MyMonad
  value::Int
end
mbind(f::Function, x::MyMonad) = f(x.value)
```

Here, the function `f` should return a new Monad: this is
not curreblty checked so you have to be careful!

## Contributing

Contributions are welcome and encouraged, so please contact
me at nicola.mosco@gmail.com or

## License

This package is distributed under the MIT [license](./LICENSE).
