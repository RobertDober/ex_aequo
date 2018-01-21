# ex_aequo

[![Build Status](https://travis-ci.org/RobertDober/ex_aequo.svg?branch=master)](https://travis-ci.org/RobertDober/ex_aequo)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_aequo.svg)](https://hex.pm/packages/ex_aequo)
[![Coverage Status](https://coveralls.io/repos/github/RobertDober/ex_aequo/badge.svg?branch=master)](https://coveralls.io/github/RobertDober/ex_aequo?branch=master)
[![Inline docs](http://inch-ci.org/github/RobertDober/ex_aequo.svg?branch=master)](http://inch-ci.org/github/RobertDober/ex_aequo)

ExAequo Elixir Tools

Meaning of the name. All nice latin expressions starting with _Ex_ are consumed at an alarming rate, so, all things
being equal, I choose this one.

<!-- begin @doc ExAequo.Enum -->
  ## ExAequo.Enum offers some extension functions for Elixir's Enum module
  
  ### Grouped Accumulation

  Groupes accumulated values of an Enum according to a function that
  indicates if two consequent items are of the same kind and if so
  how to accumulate their two values.

  The `grouped_reduce` function returns the groupes in reverse order, as,
  during traversal of lists quite often reversing the result of the 
  classical "take first and push a function of it to the result" pattern
  cancels out.
  
  An optional, `reverse: true` keyword option can be provided to reverse
  the final result for convenience.

      iex> add_same = fn {x, a}, {y, b} ->
      ...>               cond do
      ...>                 x == y -> {:cont, {x, a + b}}
      ...>                 true   -> {:stop, nil} end end
      ...> E.grouped_reduce(
      ...>   [{:a, 1}, {:a, 2}, {:b, 3}, {:b, 4}], add_same)
      [{:b, 7}, {:a, 3}]

  The `grouped_inject` function behaves almost identically to `grouped_reduce`,
  however an initial value is provided.

      iex> sub_same = fn {x, a}, {y, b} -> 
      ...>               cond do
      ...>                 x == y -> {:cont, {x, a - b}}
      ...>                 true   -> {:stop, nil}
      ...>               end
      ...>            end
      ...> E.grouped_inject(
      ...> [{:a, 1}, {:b, 2}, {:b, 2}, {:c, 2}, {:c, 1}, {:c, 1}],
      ...>  {:a, 43}, sub_same, reverse: true)
      [a: 42, b: 0, c: 0]
<!-- end @doc ExAequo.Enum -->
