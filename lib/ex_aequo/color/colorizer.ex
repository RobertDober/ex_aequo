defmodule ExAequo.Color.Colorizer do
  import ExAequo.RegexTokenizer, only: [tokenize!: 2]

  @moduledoc false

  def parse(text, options) do
    options = [
      open: "<",
      close: ">",
      escape: "\\",
      sep: ","
    ]
    |> Keyword.merge(options)

    escape = Regex.escape(Keyword.get(options, :escape))
    open = Regex.escape(Keyword.get(options, :open))
    close = Regex.escape(Keyword.get(options, :close))
    sep = Regex.escape(Keyword.get(options, :sep))

    word = "[[:alpha:]][[:alnum:]_]*"

    tokens = [
      "#{escape}(.)",
      {"#{open}(#{word}(?:#{sep}#{word})*?)#{close}", &_words_to_atoms(&1, sep)},
      "[^#{escape}#{open}]+",
    ]

    text
    |> tokenize!(tokens)
    |> List.flatten()
  end

  defp _words_to_atoms(x, sep) do
    sep
    |> Regex.compile!
    |> Regex.split(x)
    |> Enum.map(&String.to_atom/1)
  end
end

# SPDX-License-Identifier: Apache-2.0
