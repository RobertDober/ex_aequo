defmodule ExAequo.Color do
  @moduledoc ~S"""

    ## Support for the 256 ANSI and full RGB colors

    **N.B.** Does, of course, respect the usage of the `$NO_COLOR` variable

    The most basic approach is to use the generated escape sequences directly in your code, e.g.

    ```elixir
      IO.puts(ExAequo.Color.rgb(250, 148, 13) <> "Brownish Orange" <> ExAequo.Color.reset)
    ```

    The generated escape codes would be:

      iex(1)> rgb(250, 148, 13)
      "\e[38;2;250;148;13m"

      iex(2)> reset()
      "\e[0m"

    But like `IO.ANSI` a convenience function called `format` is available

      iex(3)> format(["Hello", "World"])
      ["Hello", "World"]

    As one can see it is tailor made for `IO.puts` and may be converted into a string by means of
    `IO.chardata_to_string`, this conversion can also be done by `format` itself

      iex(4)> format(["Hello", "World"], to_string: true)
      "HelloWorld"

    In order to get colors into the mix we can use, atoms (for named colors or instructions like reset)
    or triples for RGB colors

      iex(5)> format([{100, 20, 150}, "Deep Purple (pun intended)", :reset])
      ["\e[38;2;100;20;150m", "Deep Purple (pun intended)", "\e[0m"]

    And here are some nice names, which shall work on **all** terminals

      iex(6)> format([:red, "red", :blue, "blue"])
      ["\e[31m", "red", "\e[34m", "blue"]

    Oftentimes you will pass a variable to `format` and not a literal array, then the usage of the `reset: true` option
    might come in handy

      iex(7)> some_values = [:azure1, "The sky?"]
      ...(7)> format(some_values, reset: true, to_string: true)
      "\e[38;2;240;255;255mThe sky?\e[0m"

  """

  def format(bits, options \\ [])

  def format(bits, options) do
    bits1 =
      if Keyword.get(options, :reset) do
        bits ++ [:reset]
      else
        bits
      end

    output = bits1 |> Enum.map(&_format/1)

    if Keyword.get(options, :to_string) do
      IO.chardata_to_string(output)
    else
      output
    end
  end

  def reset, do: "\e[0m"

  def rgb(red, green, blue), do: "\e[38;2;#{red};#{green};#{blue}m"

  def rgb({red, green, blue}), do: rgb(red, green, blue)

  @names %{
    aqua: {0, 255, 255},
    aquamarine1: {95, 255, 215},
    aquamarine3: {95, 215, 175},
    azure1: "#f0ffff",
    black: 30,
    blue1: {0, 0, 255},
    blue3: {0, 0, 175},
    blue: 34,
    blue_violet: {95, 0, 255},
    cadet_blue: {95, 175, 135},
    chartreuse1: {135, 255, 0},
    chartreuse2: {95, 255, 0},
    chartreuse3: {95, 175, 0},
    chartreuse4: {95, 135, 0},
    cornflower_blue: {95, 135, 255},
    cornsilk1: {255, 255, 215},
    cyan1: {0, 255, 255},
    cyan2: {0, 255, 215},
    cyan3: {0, 215, 175},
    cyan: 36,
    dark_blue: {0, 0, 135},
    dark_cyan: {0, 175, 135},
    dark_goldenrod: {175, 135, 0},
    dark_green: {0, 95, 0},
    dark_khaki: {175, 175, 95},
    dark_magenta: {135, 0, 135},
    dark_olive_green1: {215, 255, 95},
    dark_olive_green2: {175, 255, 95},
    dark_olive_green3: {135, 175, 95},
    dark_orange3: {175, 95, 0},
    dark_orange: {255, 135, 0},
    dark_red: {95, 0, 0},
    dark_sea_green1: {175, 255, 215},
    dark_sea_green2: {175, 215, 175},
    dark_sea_green3: {135, 215, 175},
    dark_sea_green4: {95, 135, 95},
    dark_sea_green: {135, 175, 135},
    dark_slate_gray1: {135, 255, 255},
    dark_slate_gray2: {95, 255, 255},
    dark_slate_gray3: {135, 215, 215},
    dark_turquoise: {0, 215, 215},
    dark_violet: {135, 0, 215},
    deep_pink1: {255, 0, 135},
    deep_pink2: {255, 0, 95},
    deep_pink3: {215, 0, 95},
    deep_pink4: {95, 0, 95},
    deep_sky_blue1: {0, 175, 255},
    deep_sky_blue2: {0, 175, 215},
    deep_sky_blue3: {0, 135, 175},
    deep_sky_blue4: {0, 95, 95},
    dodger_blue1: {0, 135, 255},
    dodger_blue2: {0, 95, 255},
    dodger_blue3: {0, 95, 215},
    fuchsia: {255, 0, 255},
    gold1: {255, 215, 0},
    gold3: {175, 175, 0},
    green1: {0, 255, 0},
    green3: {0, 175, 0},
    green4: {0, 135, 0},
    green: 32,
    green_yellow: {175, 255, 0},
    grey0: {0, 0, 0},
    grey100: {255, 255, 255},
    grey11: {28, 28, 28},
    grey15: {38, 38, 38},
    grey19: {48, 48, 48},
    grey23: {58, 58, 58},
    grey27: {68, 68, 68},
    grey30: {78, 78, 78},
    grey35: {88, 88, 88},
    grey37: {95, 95, 95},
    grey39: {98, 98, 98},
    grey3: {8, 8, 8},
    grey42: {108, 108, 108},
    grey46: {118, 118, 118},
    grey50: {128, 128, 128},
    grey53: {135, 135, 135},
    grey54: {138, 138, 138},
    grey58: {148, 148, 148},
    grey62: {158, 158, 158},
    grey63: {175, 135, 175},
    grey66: {168, 168, 168},
    grey69: {175, 175, 175},
    grey70: {178, 178, 178},
    grey74: {188, 188, 188},
    grey78: {198, 198, 198},
    grey7: {18, 18, 18},
    grey82: {208, 208, 208},
    grey84: {215, 215, 215},
    grey85: {218, 218, 218},
    grey89: {228, 228, 228},
    grey93: {238, 238, 238},
    grey: {128, 128, 128},
    honeydew2: {215, 255, 215},
    hot_pink2: {215, 95, 175},
    hot_pink3: {175, 95, 135},
    hot_pink: {255, 95, 175},
    indian_red1: {255, 95, 95},
    indian_red: {175, 95, 95},
    khaki1: {255, 255, 135},
    khaki3: {215, 215, 95},
    light_coral: {255, 135, 135},
    light_cyan1: {215, 255, 255},
    light_cyan3: {175, 215, 215},
    light_goldenrod1: {255, 255, 95},
    light_goldenrod2: {215, 215, 135},
    light_goldenrod3: {215, 175, 95},
    light_green: {135, 255, 95},
    light_pink1: {255, 175, 175},
    light_pink3: {215, 135, 135},
    light_pink4: {135, 95, 95},
    light_salmon1: {255, 175, 135},
    light_salmon3: {175, 135, 95},
    light_sea_green: {0, 175, 175},
    light_sky_blue1: {175, 215, 255},
    light_sky_blue3: {135, 175, 175},
    light_slate_blue: {135, 135, 255},
    light_slate_grey: {135, 135, 175},
    light_steel_blue1: {215, 215, 255},
    light_steel_blue3: {175, 175, 215},
    light_steel_blue: {175, 175, 255},
    light_yellow3: {215, 215, 175},
    lime: {0, 255, 0},
    magenta1: {255, 0, 255},
    magenta2: {215, 0, 255},
    magenta3: {175, 0, 175},
    magenta: 35,
    maroon: {128, 0, 0},
    medium_orchid1: {215, 95, 255},
    medium_orchid3: {175, 95, 175},
    medium_orchid: {175, 95, 215},
    medium_purple1: {175, 135, 255},
    medium_purple2: {175, 95, 255},
    medium_purple3: {135, 95, 175},
    medium_purple4: {95, 95, 135},
    medium_purple: {135, 135, 215},
    medium_spring_green: {0, 255, 175},
    medium_turquoise: {95, 215, 215},
    medium_violet_red: {175, 0, 135},
    misty_rose1: {255, 215, 215},
    misty_rose3: {215, 175, 175},
    navajo_white1: {255, 215, 175},
    navajo_white3: {175, 175, 135},
    navy: {0, 0, 128},
    navy_blue: {0, 0, 95},
    olive: {128, 128, 0},
    orange1: {255, 175, 0},
    orange3: {215, 135, 0},
    orange4: {95, 95, 0},
    orange_red1: {255, 95, 0},
    orchid1: {255, 135, 255},
    orchid2: {255, 135, 215},
    orchid: {215, 95, 215},
    pale_green1: {135, 255, 175},
    pale_green3: {95, 215, 95},
    pale_turquoise1: {175, 255, 255},
    pale_turquoise4: {95, 135, 135},
    pale_violet_red1: {255, 135, 175},
    pink1: {255, 175, 215},
    pink3: {215, 135, 175},
    plum1: {255, 175, 255},
    plum2: {215, 175, 255},
    plum3: {215, 135, 215},
    plum4: {135, 95, 135},
    purple3: {95, 0, 215},
    purple4: {95, 0, 135},
    purple: {128, 0, 128},
    red1: {255, 0, 0},
    red3: {175, 0, 0},
    red: 31,
    reset: 0,
    rosy_brown: {175, 135, 135},
    royal_blue1: {95, 95, 255},
    salmon1: {255, 135, 95},
    sandy_brown: {255, 175, 95},
    sea_green1: {95, 255, 135},
    sea_green2: {95, 255, 95},
    sea_green3: {95, 215, 135},
    silver: {192, 192, 192},
    sky_blue1: {135, 215, 255},
    sky_blue2: {135, 175, 255},
    sky_blue3: {95, 175, 215},
    slate_blue1: {135, 95, 255},
    slate_blue3: {95, 95, 175},
    spring_green1: {0, 255, 135},
    spring_green2: {0, 215, 135},
    spring_green3: {0, 175, 95},
    spring_green4: {0, 135, 95},
    steel_blue1: {95, 175, 255},
    steel_blue3: {95, 135, 215},
    steel_blue: {95, 135, 175},
    tan: {215, 175, 135},
    teal: {0, 128, 128},
    thistle1: {255, 215, 255},
    thistle3: {215, 175, 215},
    turquoise2: {0, 215, 255},
    turquoise4: {0, 135, 135},
    violet: {215, 135, 255},
    wheat1: {255, 255, 175},
    wheat4: {135, 135, 95},
    white: 37,
    yellow1: {255, 255, 0},
    yellow2: {215, 255, 0},
    yellow3: {175, 215, 0},
    yellow4: {135, 135, 0},
    yellow: 33
  }

  defp _format(bit)
  defp _format(str) when is_binary(str), do: str
  defp _format(rgb) when is_tuple(rgb), do: rgb(rgb)

  defp _format(name) when is_atom(name) do
    case Map.fetch(@names, name) do
      {:ok, value} -> _transform(value)
      :error -> raise ExAequo.Error, "Illegal color or instruction name for ExAequo.Color #{name}"
    end
  end

  defp _hex_to_rgb("#" <> bytes) do
    bytes
    |> String.codepoints()
    |> Enum.chunk_every(2)
    |> Enum.map(fn p -> with {r, ""} <- Integer.parse(p |> Enum.join(), 16), do: r end)
    |> List.to_tuple()
    |> rgb()
  end

  defp _transform(value)
  defp _transform(value) when is_number(value), do: "\e[#{value}m"
  defp _transform(value) when is_binary(value), do: _hex_to_rgb(value)
  defp _transform(value), do: value
end

# SPDX-License-Identifier: Apache-2.0
