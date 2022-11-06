defmodule ExAequo.SimpleClaParser do
  @moduledoc ~S"""

  A simple Command Line Argument Parser delivering syntactically but not semantically checked Commnad Line Arguments

  Nothing in → Nothing out

      iex(1)> parse([])
      {:ok, %{args: [], kwds: %{}}}

  Positionals only

      iex(2)> parse(~W[alpha beta gamma])
      {:ok, %{args: ~W[alpha beta gamma], kwds: %{}}}

  Flags are indicated by a leading `:`

      iex(3)> parse(~W[:verbose :help alpha beta gamma])
      {:ok, %{args: ~W[alpha beta gamma], kwds: %{verbose: true, help: true}}}

  Keywords needing values are defined à la json with a trailing `:`

      iex(4)> parse(~W[level: 42 :h name: Elixir])
      {:ok, %{args: ~W[], kwds: %{level: "42", h: true, name: "Elixir"}}}

  A single `:` just ends keyword parsing

      iex(5)> parse(~W[level: 42 : :h name: Elixir])
      {:ok, %{args: ~W[:h name: Elixir], kwds: %{level: "42"}}}

  Beware of not giving values to keywords

      iex(6)> parse(~W[level:])
      {:error, %{args: [], kwds: %{}, error: "Missing value for keyword arg level!" }}

      iex(7)> parse(~W[level: : high])
      {:error, %{args: ~W[high], kwds: %{}, error: "Missing value for keyword arg level!" }}

  """

  def parse(args) do
    args
    |> _parse_args(%{args: [], kwds: %{}})
  end

  defp _parse_args(args, result, parsed_key \\ nil)
  defp _parse_args([], result, nil), do: {:ok, result}
  defp _parse_args([], result, parsed_key), do: {:error, result |> Map.put(:error, "Missing value for keyword arg #{parsed_key}!") }
  defp _parse_args([":" | args], result, nil), do: {:ok, %{ result | args: args}}
  defp _parse_args([":" | args], result, parsed_key) do 
    result = %{result | args: args}
    {:error, result |> Map.put(:error, "Missing value for keyword arg #{parsed_key}!") }
  end

  defp _parse_args([arg|rest], result, nil), do: _parse_next(arg, rest, result)
  defp _parse_args([arg|rest], result, parsed_key), do: _parse_args(rest, %{result | kwds: result.kwds |> Map.put(parsed_key, arg)})

  defp _parse_next(arg, rest, result)
  defp _parse_next(":" <> flag, rest, result), do: _parse_args(rest, %{ result | kwds: result.kwds |> Map.put(String.to_atom(flag), true)})
  defp _parse_next(arg, rest, result) do
    if String.ends_with?(arg, ":") do
      _parse_args(rest, result, arg |> String.slice(0..-2) |> String.to_atom)
    else
      {:ok, %{ result | args: [arg | rest]}}
    end
  end
end
# SPDX-License-Identifier: Apache-2.0
