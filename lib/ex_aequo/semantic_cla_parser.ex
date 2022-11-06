defmodule ExAequo.SemanticClaParser do

  alias ExAequo.SimpleClaParser
  alias __MODULE__.Description

  @moduledoc ~S"""

  This module allows to parse Command Line Arguments with attached semantics, that is

   **Constraints** and **Conversions**

  ## Errors from the `SimpleClaParser` are returned verbatim
  
      iex(1)> parse(~W[a:])
      {:error, %{args: [], kwds: %{}, error: "Missing value for keyword arg a!"}}

  
  Empty args might be ok

      iex(2)> parse([])
      {:ok, %{args: [], kwds: %{}}}

  or they might not

      iex(3)> parse([], required: [:level])
      {:error, %{args: [], kwds: %{}, errors: [missing_required_kwd: :level]}}

  ## Constraints can also do conversions

      iex(4)> parse(~W[value: 42], required: [value: :int])
      {:ok, %{args: [], kwds: %{value: 42}}}

  and if they fail we get an error

      iex(5)> parse(~W[value: 42a], required: [value: :int])
      {:error, %{args: [], kwds: %{value: "42a"}, errors: [{:bad_constraint_int, :value, "42a"}]}}

  constraints can also be defined for optional values

      iex(6)> parse(~W[value: 42], optional: [value: :int])
      {:ok, %{args: [], kwds: %{value: 42}}}

  and then it is ok, not to provide them

      iex(7)> parse([], optional: [value: :int])
      {:ok, %{args: [], kwds: %{}}}

  but if we do so we must oblige

      iex(8)> parse(~W[value: xxx], optional: [value: :int])
      {:error, %{args: [], kwds: %{value: "xxx"}, errors: [{:bad_constraint_int, :value, "xxx"}]}}

  and constraints work for positionals too

      iex(9)> parse(~W[10], optional: [{0, :int}])
      {:ok, %{args: [10], kwds: %{}}}

      iex(10)> parse(~W[ten], optional: [{0, :int}])
      {:error, %{args: ~W[ten], kwds: %{}, errors: [{:bad_constraint_int, 0, "ten"}]}}

  and as positionals are optional unless constrained with `needed:` this is ok

      iex(11)> parse([], optional: [{0, :int}])
      {:ok, %{args: [], kwds: %{}}}

  ## Custom made constraints need either return `{:ok, value}`

      iex(12)> always_42 = fn _, _ -> {:ok, 42} end
      ...(12)> parse(~W[value: hello!], optional: [value: always_42])
      {:ok, %{args: [], kwds: %{value: 42}}}

  or `{:error, message}`

      iex(13)> never_happy = fn val, key -> {:error, {:so_bad, key, "must not have #{val}"}} end
      ...(13)> parse(~W[value: hello!], optional: [value: never_happy])
      {:error, %{args: [], kwds: %{value: "hello!"}, errors: [{:so_bad, :value,  "must not have hello!"}]}}

  ## Memberships

  ### Ranges

      iex(14)> int_range = &ExAequo.SemanticClaParser.Constraints.int_range/2
      ...(14)> parse(~W[42], optional: [{0, int_range.(41, 43)}]) 
      {:ok, %{args: [42], kwds: %{}}}

      iex(15)> int_range = &ExAequo.SemanticClaParser.Constraints.int_range/2
      ...(15)> parse(~W[420], optional: [{0, int_range.(41, 43)}]) 
      {:error, %{args: ~W[420], kwds: %{}, errors: [{:not_in_int_range, 0, 420, 41..43}]}}

      iex(16)> int_range = &ExAequo.SemanticClaParser.Constraints.int_range/2
      ...(16)> parse(~W[a], optional: [{0, int_range.(41, 43)}]) 
      {:error, %{args: ["a"], kwds: %{}, errors: [{:bad_constraint_int_range, 0, "a"}]}}
    
  Note that we cannot specify the nth positional argument as required, we can however constrain the number of positional
  argumentes

      iex(17)> parse([], needed: 0..1)
      {:ok, %{args: [], kwds: %{}}}

      iex(18)> parse(~W[one], needed: 0..1)
      {:ok, %{args: ["one"], kwds: %{}}}

      iex(19)> parse(~W[:a one], needed: 0..1)
      {:ok, %{args: ["one"], kwds: %{a: true}}}

  However

      iex(20)> parse(~W[: :a one], needed: 0..1)
      {:error, %{args: [":a", "one"], kwds: %{}, errors: [{:illegal_number_of_args, 0..1, 2}]}}

  We can even forbid positionals like that

      iex(21)> parse(~W[a], needed: 0)
      {:error, %{args: ["a"], kwds: %{}, errors: [{:illegal_number_of_args, 0..0, 1}]}}

    
  """

  def parse(args, description \\ []) do
    case SimpleClaParser.parse(args) do
      {:error, _} = bad -> bad
      {:ok, maybe_good} -> _check(maybe_good, description)
    end
  end

  defp _check(args, description) do
    description
    |> Description.new
    |> Description.validate(args)
  end

end
# SPDX-License-Identifier: Apache-2.0
