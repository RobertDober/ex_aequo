defmodule ExAequo.Color.Colorizer do

  import ExAequo.RegexTokenizer, only: [tokenize!: 2]

  @moduledoc false

  def parse(text, leader) do
    escape  = Regex.escape("\\")
    leaderx = Regex.escape(leader)
    tokens = [
      "#{escape}(.)",
      "#{leaderx}(?!\\w)",
      { "#{leaderx}(\\w+)#{leaderx}", &String.to_atom/1 },
      ".[^#{escape}#{leaderx}]+" ]
    tokenize!(text, tokens)
  end
end

# SPDX-License-Identifier: Apache-2.0
