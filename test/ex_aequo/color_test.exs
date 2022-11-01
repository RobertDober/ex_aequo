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

  describe "legacy ANSI colors" do
    [
      {30, :black },
      {31, :red },
      {32, :green },
      {33, :yellow },
      {34, :blue },
      {35, :magenta },
      {36, :cyan },
      {37, :white}
    ] |> Enum.each( fn {escape, name} ->
      expected = ["\e[#{escape}m", "#{name}"]
      input = [name, to_string(name)]
      test_name = "legacy ANSI color #{name}"
      test test_name do
        assert format(unquote(input)) == unquote(expected)
      end
    end)
  end

  describe "256 colors space" do
    (0..255)
    |> Enum.each(fn n ->
      expected = ["\e[38;5;#{n}m"]
      input = ["color#{n}" |> String.to_atom]
      test_name = "color #{n} from 256 colors space"
      test test_name do
        assert format(unquote(input)) == unquote(expected)
      end
    end)
  end

  describe "error message" do
    test "not a color" do
      assert_raise ExAequo.Error, fn ->
        format([:definitely_not_a_colorzjieozfef])
      end
    end
  end

end
# SPDX-License-Identifier: Apache-2.0
