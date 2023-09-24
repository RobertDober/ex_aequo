defmodule ExAequo.RegexTokenizer do
  alias ExAequo.RegexTokenizer.Tokenizer

  @moduledoc ~S"""
  Allows tokenizing text by means of priorized regular expressions
  """

  @doc ~S"""
  A simple example first

      iex(1)> tokens = [
      ...(1)>   { "\\d+", &String.to_integer/1 },
      ...(1)>   { "[\\s,]+", &nil_fn/1 },                   # from ExAequo.Fn
      ...(1)>   { "\\w+", &String.to_atom/1 } ]
      ...(1)> tokenize("42, and 43", tokens)
      {:ok, [42, nil, :and, nil, 43]}

  If we want to ignore `nil` (or other values)

      iex(2)> tokens = [
      ...(2)>   { "\\d+", &String.to_integer/1 },
      ...(2)>   { "[\\s,]+", &nil_fn/1 },                   # from ExAequo.Fn
      ...(2)>   { "\\w+", &String.to_atom/1 } ]
      ...(2)> tokenize("42, and 43", tokens, ignores: [nil])
      {:ok, [42, :and, 43]}

  And a little bit more complex example as used in this library

      iex(3)> tokens = [
      ...(3)>   "\\\\(.)",                                  # same as {"\\.\\s+", &(&1)}
      ...(3)>   "\\.\\s+",
      ...(3)>   { "\\.(\\w+)\\.", &String.to_atom/1 },
      ...(3)>   ".[^\\\\.]+" ]
      ...(3)> [
      ...(3)> tokenize!(".red.hello", tokens),
      ...(3)> tokenize!(". \\.red.blue\\..green.", tokens)]
      [
        [:red, "hello"],
        [". ", ".", "red", ".blue", ".", :green]
      ]

  """

  def tokenize(string, tokens, options \\ []) do
    tokens1 = _mk_tokens(tokens)
    options1 = _mk_options(options)
    Tokenizer.tokenize(string, tokens1, options1)
  end

  def tokenize!(string, tokens, options \\ []) do
    case tokenize(string, tokens, options) do
      {:ok, tokens} -> tokens
      {:error, result} -> raise "Lexing error, #{inspect(result)}"
    end
  end

  defp _mk_ignores(options) do
    ignores = Keyword.get(options, :ignores, [])
    Keyword.put(options, :ignores, MapSet.new(ignores))
  end

  defp _mk_options(options) do
    defaults = [
      strict: true
    ]

    defaults
    |> Keyword.merge(options)
    |> _mk_ignores()
  end

  defp _mk_rgx(rgx), do: Regex.compile!("\\A#{rgx}")

  defp _mk_token(token)
  defp _mk_token({token, fun}), do: {_mk_rgx(token), fun}
  defp _mk_token(token), do: {_mk_rgx(token), & &1}

  defp _mk_tokens(tokens), do: Enum.map(tokens, &_mk_token/1)
end

# SPDX-License-Identifier: Apache-2.0
