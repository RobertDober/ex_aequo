defmodule ExAequo.RegexTokenizer.Tokenizer do
  @moduledoc false

  def tokenize(string, tokens, options, result \\ [])
  def tokenize("", _t, options, result), do: _ok(result, options)

  def tokenize(text, tokens, options, result) do
    case Enum.find_value(tokens, &_find_token(&1, text)) do
      nil -> _maybe_error(result, text, options)
      {token, rest} -> tokenize(rest, tokens, options, [token|result])
    end
  end

  defp _find_token({rgx, fun}, text) do
    # IO.inspect({rgx, text})
    case Regex.run(rgx, text) do
      # [m] -> IO.inspect({:match, m});_rest(text, fun, m, m)
      [m] -> _rest(text, fun, m, m)
      # [m, c | _] -> IO.inspect({:capture, m, c}); _rest(text, fun, m, c)
      [m, c | _] -> _rest(text, fun, m, c)
      nil -> nil
    end
  end

  defp _ignore(tokens, ignores, result)
  defp _ignore([], _, result), do: result

  defp _ignore([h | t], ignores, result) do
    if MapSet.member?(ignores, h) do
      _ignore(t, ignores, result)
    else
      _ignore(t, ignores, [h | result])
    end
  end

  defp _maybe_error(result, text, options) do
    if Keyword.get(options, :strict) do
      {:error, Enum.reverse(result), text}
    else
      _ok([text | result], options)
    end
  end

  defp _ok(result, options) do
    ignores = Keyword.get(options, :ignores)

    if Enum.empty?(ignores) do
      {:ok, Enum.reverse(result)}
    else
      {:ok, _ignore(result, ignores, [])}
    end
  end

  defp _rest(text, fun, match, capture) do
    {fun.(capture), String.slice(text, String.length(match)..-1)}
  end
end

# SPDX-License-Identifier: Apache-2.0
