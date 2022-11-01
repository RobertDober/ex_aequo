defmodule Test.ExAequo.ColorTest do
  use ExUnit.Case
  doctest ExAequo.Color, import: true

  alias Support.Random
  import ExAequo.Color

  describe "rgb" do
    # 3 param RGB form
    Random.tuple_samples(0..255, 3, 20)
    |> Enum.each( fn {red, green, blue} ->
      expected = "\e[38;2;#{red};#{green};#{blue}m"
      test_name = "rgb(#{red}, #{green}, #{blue})"
      test test_name do
        assert rgb(unquote(red), unquote(green), unquote(blue)) == unquote(expected)
      end
    end)

    # Triple RGB form
    Random.tuple_samples(0..255, 3, 20)
    |> Enum.each( fn {red, green, blue} ->
      expected = "\e[38;2;#{red};#{green};#{blue}m"
      test_name = "rgb({#{red}, #{green}, #{blue}})"
      test test_name do
        assert rgb({unquote(red), unquote(green), unquote(blue)}) == unquote(expected)
      end
    end)
  end
end
# SPDX-License-Identifier: Apache-2.0
