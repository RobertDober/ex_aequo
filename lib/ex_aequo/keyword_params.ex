defmodule ExAequo.KeywordParams do

  use ExAequo.Types

  @moduledoc """
  ## Tools to facilitate dispatching on keyword parameters, used in contexts like the following

        @defaults [a: 1, b: false] # Keyword or Map
        def some_fun(..., options \\ []) # options again can be a Keyword or Map
          {a, b} = tuple_from_params(@defaults, options, [:a, :b])

  ### Merging defaults and actual parameters

  Its most useful feature is that you will get a map whatever the mixtures of maps and keywords the
  input was

      iex(0)> merge_params([])
      %{}

      iex(1)> merge_params([a: 1], %{b: 2})
      %{a: 1, b: 2}

      iex(2)> merge_params(%{a: 1}, [a: 2, b: 2])
      %{a: 2, b: 2}

  #### Strict merging

  _Not implemented yet_

  ### Extracting params from the merged defaults and actuals

      iex(3)> defaults = [foo: false, depth: 3]
      ...(3)> tuple_from_params(defaults, %{foo: true}, [:foo, :depth])
      {true, 3}

  As defaults are required a missing parameter will raise an Error

      iex(4)> try do
      ...(4)>   tuple_from_params([], [foo: 1], [:bar])
      ...(4)> rescue
      ...(4)>   KeyError -> :caught
      ...(4)> end
      :caught

  Alternatively on can extract a map

      iex(5)> map_from_params([], [hello: "world"], [:hello])
      %{hello: "world"}

  """

  @doc """
  This is the 2 param form which is identical to an empty default map
      iex(6)> map_from_params(%{a: 1, b: 2}, [:a])
      %{a: 1}
  """
  def map_from_params(actual, keys), do: map_from_params(%{}, actual, keys)
  def map_from_params(default, actual, keys) do
    merged = merge_params(default, actual)
    keys
    |> Enum.reduce(%{}, fn key, values -> Map.put(values, key, Map.fetch!(merged, key)) end)
  end

  def merge_params(actual), do: merge_params(%{}, actual)

  def merge_params(default, actual)
  def merge_params(default, actual) when is_list(default), do: default |> Enum.into(%{}) |> merge_params(actual)
  def merge_params(default, actual) when is_list(actual), do: merge_params(default, actual |> Enum.into(%{}))
  def merge_params(default, actual), do: Map.merge(default, actual)

  @doc """
  This is the 2 param form which is identical to an empty default map
      iex(7)> tuple_from_params(%{a: 1, b: 2}, [:b, :a])
      {2, 1}
  """
  def tuple_from_params(actual, keys), do: tuple_from_params([], actual, keys)

  def tuple_from_params(default, actual, keys) do
    merged = merge_params(default, actual)
    keys
    |> Enum.reduce([], fn key, values -> [Map.fetch!(merged, key)|values] end)
    |> Enum.reverse
    |> List.to_tuple
  end

end
