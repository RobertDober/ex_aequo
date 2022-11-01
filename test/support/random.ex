defmodule Support.Random do
  def sample(%Range{first: first, last: last}) do
    :rand.uniform(last - first + 1) + first - 1
  end

  def samples(range, number\\10) do
    (1..number)
    |> Enum.map(fn _ -> sample(range) end)
  end

  def tuple_sample(range, length \\ 2) do
    (1..length)
    |> Enum.map( fn _ -> sample(range) end)
    |> List.to_tuple
  end
  def tuple_samples(range, length \\ 2 , number \\ 10) do
    (1..number)
    |> Enum.map(fn _ -> tuple_sample(range, length) end)
  end
end
# SPDX-License-Identifier: Apache-2.0
