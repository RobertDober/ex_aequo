defmodule ExAequo.Color.Colorizer do

  @moduledoc false

  def parse(text, leader) do
    leaderx = Regex.escape(leader)
    escaped = Regex.compile!("\\A" <> Regex.escape("\#{leader}(.*)")) |> IO.inspect() 
    spaced = Regex.compile!("\\A(#{Regex.escape(leader)} )(.*)")
    color = Regex.compile!("\\A#{leaderx}(\\w+)#{leaderx}(.*)")
    verb = Regex.compile!("\\A(.[^#{leaderx}]*)(.*)")
    _parse(text, [], {escaped, spaced, color, verb, leader})
  end

  defp _parse(text, result, rules)
  defp _parse("", result, _), do: Enum.reverse(result)
  defp _parse(text, result, {escaped, spaced, color, verb, leader}=rules) do
    case Regex.run(escaped, text) do
      [_, rest] -> _parse(rest, [leader|>IO.inspect(label: :escaped)|result], rules)
      nil -> case Regex.run(spaced, text) do
        [_, sp, rest] -> _parse(rest, [sp|>IO.inspect(label: :spaced)|result], rules)
        nil -> case Regex.run(color, text) do
          [_, col, rest] -> _parse(rest, [String.to_atom(col)|>IO.inspect(label: :color)|result], rules)
          nil -> case Regex.run(verb, text) do
            [_, v, rest] -> _parse(rest, [v|>IO.inspect(label: :verb)|result], rules)
            nil -> raise "Illegal input: #{text}"
          end
        end
      end
    end
  end
end

# SPDX-License-Identifier: Apache-2.0
