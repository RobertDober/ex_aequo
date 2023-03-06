# ex_aequo

<!--
DO NOT EDIT THIS FILE
It has been generated from the template `README.md.eex` by Extractly (https://github.com/RobertDober/extractly.git)
and any changes you make in this file will most likely be lost
-->

[![CI](https://github.com/RobertDober/ex_aequo/actions/workflows/ci.yml/badge.svg)](https://github.com/RobertDober/ex_aequo/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/RobertDober/ex_aequo/badge.svg?branch=master)](https://coveralls.io/github/RobertDober/ex_aequo?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_aequo.svg)](https://hex.pm/packages/ex_aequo)
[![Hex.pm](https://img.shields.io/hexpm/dw/ex_aequo.svg)](https://hex.pm/packages/ex_aequo)
[![Hex.pm](https://img.shields.io/hexpm/dt/ex_aequo.svg)](https://hex.pm/packages/ex_aequo)

# ExAequo Elixir Tools

### Installation:

```elxir
  { :ex_aequo, ">= 0.5.1" }
```

Meaning of the name. All nice latin expressions starting with _Ex_ are consumed at an alarming rate, so, all things
being equal, I choose this one.

## ExAequo.SimpleClaParser


A simple Command Line Argument Parser delivering syntactically but not semantically checked Commnad Line Arguments

Nothing in → Nothing out

```elixir
    iex(1)> parse([])
    {:ok, %{args: [], kwds: %{}}}
```

Positionals only

```elixir
    iex(2)> parse(~W[alpha beta gamma])
    {:ok, %{args: ~W[alpha beta gamma], kwds: %{}}}
```

Flags are indicated by a leading `:`

```elixir
    iex(3)> parse(~W[:verbose :help alpha beta gamma])
    {:ok, %{args: ~W[alpha beta gamma], kwds: %{verbose: true, help: true}}}
```

Keywords needing values are defined à la json with a trailing `:`

```elixir
    iex(4)> parse(~W[level: 42 :h name: Elixir])
    {:ok, %{args: ~W[], kwds: %{level: "42", h: true, name: "Elixir"}}}
```

A single `:` just ends keyword parsing

```elixir
    iex(5)> parse(~W[level: 42 : :h name: Elixir])
    {:ok, %{args: ~W[:h name: Elixir], kwds: %{level: "42"}}}
```

Beware of not giving values to keywords

```elixir
    iex(6)> parse(~W[level:])
    {:error, %{args: [], kwds: %{}, error: "Missing value for keyword arg level!" }}
```

```elixir
    iex(7)> parse(~W[level: : high])
    {:error, %{args: ~W[high], kwds: %{}, error: "Missing value for keyword arg level!" }}
```



## ExAequo.SemanticClaParser


This module allows to parse Command Line Arguments with attached semantics, that is

 **Constraints** and **Conversions**

## Errors from the `SimpleClaParser` are returned verbatim

```elixir
    iex(1)> parse(~W[a:])
    {:error, %{args: [], kwds: %{}, error: "Missing value for keyword arg a!"}}
```


Empty args might be ok

```elixir
    iex(2)> parse([])
    {:ok, %{args: [], kwds: %{}}}
```

or they might not

```elixir
    iex(3)> parse([], required: [:level])
    {:error, %{args: [], kwds: %{}, errors: [missing_required_kwd: :level]}}
```

## Constraints can also do conversions

```elixir
    iex(4)> parse(~W[value: 42], required: [value: :int])
    {:ok, %{args: [], kwds: %{value: 42}}}
```

and if they fail we get an error

```elixir
    iex(5)> parse(~W[value: 42a], required: [value: :int])
    {:error, %{args: [], kwds: %{value: "42a"}, errors: [{:bad_constraint_int, :value, "42a"}]}}
```

constraints can also be defined for optional values

```elixir
    iex(6)> parse(~W[value: 42], optional: [value: :int])
    {:ok, %{args: [], kwds: %{value: 42}}}
```

and then it is ok, not to provide them

```elixir
    iex(7)> parse([], optional: [value: :int])
    {:ok, %{args: [], kwds: %{}}}
```

but if we do so we must oblige

```elixir
    iex(8)> parse(~W[value: xxx], optional: [value: :int])
    {:error, %{args: [], kwds: %{value: "xxx"}, errors: [{:bad_constraint_int, :value, "xxx"}]}}
```

and constraints work for positionals too

```elixir
    iex(9)> parse(~W[10], optional: [{0, :int}])
    {:ok, %{args: [10], kwds: %{}}}
```

```elixir
    iex(10)> parse(~W[ten], optional: [{0, :int}])
    {:error, %{args: ~W[ten], kwds: %{}, errors: [{:bad_constraint_int, 0, "ten"}]}}
```

and as positionals are optional unless constrained with `needed:` this is ok

```elixir
    iex(11)> parse([], optional: [{0, :int}])
    {:ok, %{args: [], kwds: %{}}}
```

## Custom made constraints need either return `{:ok, value}`

```elixir
    iex(12)> always_42 = fn _, _ -> {:ok, 42} end
    ...(12)> parse(~W[value: hello!], optional: [value: always_42])
    {:ok, %{args: [], kwds: %{value: 42}}}
```

or `{:error, message}`

```elixir
    iex(13)> never_happy = fn val, key -> {:error, {:so_bad, key, "must not have #{val}"}} end
    ...(13)> parse(~W[value: hello!], optional: [value: never_happy])
    {:error, %{args: [], kwds: %{value: "hello!"}, errors: [{:so_bad, :value,  "must not have hello!"}]}}
```

## Memberships

### Ranges

```elixir
    iex(14)> int_range = &ExAequo.SemanticClaParser.Constraints.int_range/2
    ...(14)> parse(~W[42], optional: [{0, int_range.(41, 43)}]) 
    {:ok, %{args: [42], kwds: %{}}}
```

```elixir
    iex(15)> int_range = &ExAequo.SemanticClaParser.Constraints.int_range/2
    ...(15)> parse(~W[420], optional: [{0, int_range.(41, 43)}]) 
    {:error, %{args: ~W[420], kwds: %{}, errors: [{:not_in_int_range, 0, 420, 41..43}]}}
```

```elixir
    iex(16)> int_range = &ExAequo.SemanticClaParser.Constraints.int_range/2
    ...(16)> parse(~W[a], optional: [{0, int_range.(41, 43)}]) 
    {:error, %{args: ["a"], kwds: %{}, errors: [{:bad_constraint_int_range, 0, "a"}]}}
```
  
Note that we cannot specify the nth positional argument as required, we can however constrain the number of positional
argumentes

```elixir
    iex(17)> parse([], needed: 0..1)
    {:ok, %{args: [], kwds: %{}}}
```

```elixir
    iex(18)> parse(~W[one], needed: 0..1)
    {:ok, %{args: ["one"], kwds: %{}}}
```

```elixir
    iex(19)> parse(~W[:a one], needed: 0..1)
    {:ok, %{args: ["one"], kwds: %{a: true}}}
```

However

```elixir
    iex(20)> parse(~W[: :a one], needed: 0..1)
    {:error, %{args: [":a", "one"], kwds: %{}, errors: [{:illegal_number_of_args, 0..1, 2}]}}
```

We can even forbid positionals like that

```elixir
    iex(21)> parse(~W[a], needed: 0)
    {:error, %{args: ["a"], kwds: %{}, errors: [{:illegal_number_of_args, 0..0, 1}]}}
```

  


## ExAequo.File

## ExAequo.File



### ExAequo.File.files/1


### ExAequo.File.files_with_stat/1

expands `wc` and zips each matching file into a list of `{String.t, File.Stat.t}`

### ExAequo.File.readlines/1


read a file into lines

```elixir
    iex(0)> readlines(Path.join(~W[test fixtures a_simple_file.txt]))
    ["Line 1", "Line two", " Una terza linea"]
```

### ExAequo.File.today/1

expands `wc` and zips each matching file into a list of `{String.t, File.Stat.t}`, then
filters only the files from today


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

```elixir
      iex(0)> add_same = fn {x, a}, {y, b} ->
      ...(0)>               cond do
      ...(0)>                 x == y -> {:cont, {x, a + b}}
      ...(0)>                 true   -> {:stop, nil} end end
      ...(0)> E.grouped_reduce(
      ...(0)>   [{:a, 1}, {:a, 2}, {:b, 3}, {:b, 4}], add_same)
      [{:b, 7}, {:a, 3}]
```

The `grouped_inject` function behaves almost identically to `grouped_reduce`,
however an initial value is provided.

```elixir
      iex(1)> sub_same = fn {x, a}, {y, b} -> 
      ...(1)>               cond do
      ...(1)>                 x == y -> {:cont, {x, a - b}}
      ...(1)>                 true   -> {:stop, nil}
      ...(1)>               end
      ...(1)>            end
      ...(1)> E.grouped_inject(
      ...(1)> [{:a, 1}, {:b, 2}, {:b, 2}, {:c, 2}, {:c, 1}, {:c, 1}],
      ...(1)>  {:a, 43}, sub_same, reverse: true)
      [a: 42, b: 0, c: 0]
```


## ExAequo.Color


  ## Support for the 256 ANSI and full RGB colors

  **N.B.** Does, of course, respect the usage of the `$NO_COLOR` variable

  The most basic approach is to use the generated escape sequences directly in your code, e.g.

  ```elixir
    IO.puts(ExAequo.Color.rgb(250, 148, 13) <> "Brownish Orange" <> ExAequo.Color.reset)
  ```

### `rgb`

  The generated escape codes would be:

```elixir
    iex(1)> rgb(250, 148, 13)
    "\e[38;2;250;148;13m"
```

```elixir
    iex(2)> reset()
    "\e[0m"
```

### `format`

  But like `IO.ANSI` a convenience function called `format` is available

```elixir
    iex(3)> format(["Hello", "World"])
    ["Hello", "World"]
```

  As one can see it is tailor made for `IO.puts` and may be converted into a string by means of
  `IO.chardata_to_string`, this conversion can also be done by `format` itself

```elixir
    iex(4)> format(["Hello", "World"], to_string: true)
    "HelloWorld"
```

#### RGB

  In order to get colors into the mix we can use, atoms (for named colors or instructions like reset)
  or triples for RGB colors

```elixir
    iex(5)> format([{100, 20, 150}, "Deep Purple (pun intended)", :reset])
    ["\e[38;2;100;20;150m", "Deep Purple (pun intended)", "\e[0m"]
```

#### 8 Color Space

  And here are some nice names, which shall work on **all** terminals

```elixir
    iex(6)> format([:red, "red", :blue, "blue"])
    ["\e[31m", "red", "\e[34m", "blue"]
```

  Oftentimes you will pass a variable to `format` and not a literal array, then the usage of the `reset: true` option
  might come in handy

```elixir
    iex(7)> some_values = [:azure1, "The sky?"]
    ...(7)> format(some_values, reset: true, to_string: true)
    "\e[38;2;240;255;255mThe sky?\e[0m"
```

#### 256 Colors

```elixir
    iex(8)> format([:color242, :color142, :color42])
    ["\e[38;5;242m", "\e[38;5;142m", "\e[38;5;42m"]
```


## Escript `ls_colors`


Test some colors

```sh
    ls_colors :red Red :reset 100,20,150 Deep Purple
```

Show some colors

```sh
    ls_colors -l|--list red_range green_range blue_range
```


## Tools to facilitate dispatching on keyword parameters, used in contexts like the following

      @defaults [a: 1, b: false] # Keyword or Map
      def some_fun(..., options \ []) # options again can be a Keyword or Map
        {a, b} = tuple_from_params(@defaults, options, [:a, :b])

### Merging defaults and actual parameters

Its most useful feature is that you will get a map whatever the mixtures of maps and keywords the
input was

```elixir
    iex(0)> merge_params([])
    %{}

```elixir
    iex(1)> merge_params([a: 1], %{b: 2})
    %{a: 1, b: 2}
```

```elixir
    iex(2)> merge_params(%{a: 1}, [a: 2, b: 2])
    %{a: 2, b: 2}
```
```

#### Strict merging

_Not implemented yet_

### Extracting params from the merged defaults and actuals

```elixir
    iex(3)> defaults = [foo: false, depth: 3]
    ...(3)> tuple_from_params(defaults, %{foo: true}, [:foo, :depth])
    {true, 3}
```

As defaults are required a missing parameter will raise an Error

```elixir
    iex(4)> try do
    ...(4)>   tuple_from_params([], [foo: 1], [:bar])
    ...(4)> rescue
    ...(4)>   KeyError -> :caught
    ...(4)> end
    :caught
```

Alternatively on can extract a map

```elixir
    iex(5)> map_from_params([], [hello: "world"], [:hello])
    %{hello: "world"}
```



This is the 2 param form which is identical to an empty default map

```elixir
    iex(6)> map_from_params(%{a: 1, b: 2}, [:a])
    %{a: 1}
```

This is the 2 param form which is identical to an empty default map

```elixir
    iex(7)> tuple_from_params(%{a: 1, b: 2}, [:b, :a])
    {2, 1}
```


    iex(0)> basename_without_ext("a/b/c.txt")
    "c"

```elixir
    iex(1)> basename_without_ext("a/b/c.txt.eex")
    "c.txt"
```

```elixir
    iex(2)> basename_without_ext("a/b/c")
    "c"
```

    iex(3)> fullname_without_ext("a/b/c.txt")
    "a/b/c"

```elixir
    iex(4)> fullname_without_ext("a/b/c.txt.eex")
    "a/b/c.txt"
```

```elixir
    iex(5)> fullname_without_ext("a/b/c")
    "a/b/c"
```

```elixir
    iex(6)> fullname_without_ext("/c")
    "/c"
```


<!-- SPDX-License-Identifier: Apache-2.0 -->
