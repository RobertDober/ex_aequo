defmodule ExAequo.Color.Escript do
  
  import ExAequo.Color, only: [format: 2]

  def main(_args) do
    puts("Coming soon")
  end

  defp puts(args)
  defp puts(args) when is_binary(args), do: puts([args])
  defp puts(args) do
    args
    |> format(reset: true)
    |> IO.puts
  end
end
# SPDX-License-Identifier: Apache-2.0
