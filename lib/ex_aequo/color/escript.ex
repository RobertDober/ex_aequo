defmodule ExAequo.Color.Escript do
  import ExAequo.Color, only: [format: 1, format: 2]

  def main(args)
  def main(["--list", r, g, b]), do: _list(r, g, b, "20")
  def main(["-l", r, g, b]), do: _list(r, g, b, "20")
  def main(["--list", r, g, b, s]), do: _list(r, g, b, s)
  def main(["-l", r, g, b, s]), do: _list(r, g, b, s)
  def main(["--256"]), do: _ls256()
  def main(args), do: _echo(args)

  defp _echo(args) do
    args
    |> Enum.map(&_format/1)
    |> puts()
  end

  defp _format(arg)
  defp _format(":" <> sym), do: String.to_atom(sym)
  defp _format(arg) do
    case String.split(arg, ",") do
      [_, _, _] = t -> t |> Enum.map(&String.to_integer/1) |> List.to_tuple
      _ -> arg
    end
  end

  defp _list(r, g, b, s) do
    s = String.to_integer(s)
    r = _range(r, s)
    g = _range(g, s)
    b = _range(b, s)
    all = for x <- r, y <- g, z <- b, do: {x, y, z}

    all
    |> Enum.each(fn rgb ->
      puts([rgb, inspect(rgb)])
    end)
  end

  defp _ls256 do
    for high <- 0..31 do
      for color <- 8*high..(8*high+7) do
         color_str = "color#{color}"
         color_sym = String.to_atom(color_str)
         [color_sym, "\\e[38;5;252m #{color_str}"] 
      end
      |> Enum.map( fn [sym, str] ->
        format([sym, String.pad_trailing(str, 23, " ")])
      end)
      |> IO.puts
    end
  end

  defp _range(r, s) do
    rs =
      (String.split(r, "..") ++ [r])
      |> Enum.take(2)
      |> Enum.map(&String.to_integer/1)

    args = rs ++ [s]
    apply(Range, :new, args)
  end

  defp puts(args) do
    args
    |> format(reset: true)
    |> IO.puts()
  end
end

# SPDX-License-Identifier: Apache-2.0
