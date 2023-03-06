defmodule ExAequo.Color do
  @moduledoc ~S"""

    ## Support for the 256 ANSI and full RGB colors

    **N.B.** Does, of course, respect the usage of the `$NO_COLOR` variable

    The most basic approach is to use the generated escape sequences directly in your code, e.g.

    ```elixir
      IO.puts(ExAequo.Color.rgb(250, 148, 13) <> "Brownish Orange" <> ExAequo.Color.reset)
    ```

  ### `rgb`

    The generated escape codes would be:

      iex(1)> rgb(250, 148, 13)
      "\e[38;2;250;148;13m"

      iex(2)> reset()
      "\e[0m"

  ### `format`

    But like `IO.ANSI` a convenience function called `format` is available

      iex(3)> format(["Hello", "World"])
      ["Hello", "World"]

    As one can see it is tailor made for `IO.puts` and may be converted into a string by means of
    `IO.chardata_to_string`, this conversion can also be done by `format` itself

      iex(4)> format(["Hello", "World"], to_string: true)
      "HelloWorld"

  ### `putc`

    A shortcut for

    ```elixir
        color_definition_list
        |> format
        |> IO.puts
    ```

  #### RGB

    In order to get colors into the mix we can use, atoms (for named colors or instructions like reset)
    or triples for RGB colors

      iex(5)> format([{100, 20, 150}, "Deep Purple (pun intended)", :reset])
      ["\e[38;2;100;20;150m", "Deep Purple (pun intended)", "\e[0m"]

  #### 8 Color Space

    And here are some nice names, which shall work on **all** terminals

      iex(6)> format([:red, "red", :blue, "blue"])
      ["\e[31m", "red", "\e[34m", "blue"]

    Oftentimes you will pass a variable to `format` and not a literal array, then the usage of the `reset: true` option
    might come in handy

      iex(7)> some_values = [:azure1, "The sky?"]
      ...(7)> format(some_values, reset: true, to_string: true)
      "\e[38;2;240;255;255mThe sky?\e[0m"

  #### 256 Colors

      iex(8)> format([:color242, :color142, :color42])
      ["\e[38;5;242m", "\e[38;5;142m", "\e[38;5;42m"]


  ## Escript `ls_colors`


  Test some colors

  ```sh
      ls_colors :red Red :reset 100,20,150 Deep Purple
  ```

  Show some colors

  ```sh
      ls_colors -l|--list red_range green_range blue_range
  ```
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

  def putc(colordef, device \\ :stdio)
  def putc(colordef, device) do
    colorstring = format(colordef)
    IO.puts(device, colorstring)
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
    color0: "\e[38;5;0m",
    color1: "\e[38;5;1m",
    color2: "\e[38;5;2m",
    color3: "\e[38;5;3m",
    color4: "\e[38;5;4m",
    color5: "\e[38;5;5m",
    color6: "\e[38;5;6m",
    color7: "\e[38;5;7m",
    color8: "\e[38;5;8m",
    color9: "\e[38;5;9m",
    color10: "\e[38;5;10m",
    color11: "\e[38;5;11m",
    color12: "\e[38;5;12m",
    color13: "\e[38;5;13m",
    color14: "\e[38;5;14m",
    color15: "\e[38;5;15m",
    color16: "\e[38;5;16m",
    color17: "\e[38;5;17m",
    color18: "\e[38;5;18m",
    color19: "\e[38;5;19m",
    color20: "\e[38;5;20m",
    color21: "\e[38;5;21m",
    color22: "\e[38;5;22m",
    color23: "\e[38;5;23m",
    color24: "\e[38;5;24m",
    color25: "\e[38;5;25m",
    color26: "\e[38;5;26m",
    color27: "\e[38;5;27m",
    color28: "\e[38;5;28m",
    color29: "\e[38;5;29m",
    color30: "\e[38;5;30m",
    color31: "\e[38;5;31m",
    color32: "\e[38;5;32m",
    color33: "\e[38;5;33m",
    color34: "\e[38;5;34m",
    color35: "\e[38;5;35m",
    color36: "\e[38;5;36m",
    color37: "\e[38;5;37m",
    color38: "\e[38;5;38m",
    color39: "\e[38;5;39m",
    color40: "\e[38;5;40m",
    color41: "\e[38;5;41m",
    color42: "\e[38;5;42m",
    color43: "\e[38;5;43m",
    color44: "\e[38;5;44m",
    color45: "\e[38;5;45m",
    color46: "\e[38;5;46m",
    color47: "\e[38;5;47m",
    color48: "\e[38;5;48m",
    color49: "\e[38;5;49m",
    color50: "\e[38;5;50m",
    color51: "\e[38;5;51m",
    color52: "\e[38;5;52m",
    color53: "\e[38;5;53m",
    color54: "\e[38;5;54m",
    color55: "\e[38;5;55m",
    color56: "\e[38;5;56m",
    color57: "\e[38;5;57m",
    color58: "\e[38;5;58m",
    color59: "\e[38;5;59m",
    color60: "\e[38;5;60m",
    color61: "\e[38;5;61m",
    color62: "\e[38;5;62m",
    color63: "\e[38;5;63m",
    color64: "\e[38;5;64m",
    color65: "\e[38;5;65m",
    color66: "\e[38;5;66m",
    color67: "\e[38;5;67m",
    color68: "\e[38;5;68m",
    color69: "\e[38;5;69m",
    color70: "\e[38;5;70m",
    color71: "\e[38;5;71m",
    color72: "\e[38;5;72m",
    color73: "\e[38;5;73m",
    color74: "\e[38;5;74m",
    color75: "\e[38;5;75m",
    color76: "\e[38;5;76m",
    color77: "\e[38;5;77m",
    color78: "\e[38;5;78m",
    color79: "\e[38;5;79m",
    color80: "\e[38;5;80m",
    color81: "\e[38;5;81m",
    color82: "\e[38;5;82m",
    color83: "\e[38;5;83m",
    color84: "\e[38;5;84m",
    color85: "\e[38;5;85m",
    color86: "\e[38;5;86m",
    color87: "\e[38;5;87m",
    color88: "\e[38;5;88m",
    color89: "\e[38;5;89m",
    color90: "\e[38;5;90m",
    color91: "\e[38;5;91m",
    color92: "\e[38;5;92m",
    color93: "\e[38;5;93m",
    color94: "\e[38;5;94m",
    color95: "\e[38;5;95m",
    color96: "\e[38;5;96m",
    color97: "\e[38;5;97m",
    color98: "\e[38;5;98m",
    color99: "\e[38;5;99m",
    color100: "\e[38;5;100m",
    color101: "\e[38;5;101m",
    color102: "\e[38;5;102m",
    color103: "\e[38;5;103m",
    color104: "\e[38;5;104m",
    color105: "\e[38;5;105m",
    color106: "\e[38;5;106m",
    color107: "\e[38;5;107m",
    color108: "\e[38;5;108m",
    color109: "\e[38;5;109m",
    color110: "\e[38;5;110m",
    color111: "\e[38;5;111m",
    color112: "\e[38;5;112m",
    color113: "\e[38;5;113m",
    color114: "\e[38;5;114m",
    color115: "\e[38;5;115m",
    color116: "\e[38;5;116m",
    color117: "\e[38;5;117m",
    color118: "\e[38;5;118m",
    color119: "\e[38;5;119m",
    color120: "\e[38;5;120m",
    color121: "\e[38;5;121m",
    color122: "\e[38;5;122m",
    color123: "\e[38;5;123m",
    color124: "\e[38;5;124m",
    color125: "\e[38;5;125m",
    color126: "\e[38;5;126m",
    color127: "\e[38;5;127m",
    color128: "\e[38;5;128m",
    color129: "\e[38;5;129m",
    color130: "\e[38;5;130m",
    color131: "\e[38;5;131m",
    color132: "\e[38;5;132m",
    color133: "\e[38;5;133m",
    color134: "\e[38;5;134m",
    color135: "\e[38;5;135m",
    color136: "\e[38;5;136m",
    color137: "\e[38;5;137m",
    color138: "\e[38;5;138m",
    color139: "\e[38;5;139m",
    color140: "\e[38;5;140m",
    color141: "\e[38;5;141m",
    color142: "\e[38;5;142m",
    color143: "\e[38;5;143m",
    color144: "\e[38;5;144m",
    color145: "\e[38;5;145m",
    color146: "\e[38;5;146m",
    color147: "\e[38;5;147m",
    color148: "\e[38;5;148m",
    color149: "\e[38;5;149m",
    color150: "\e[38;5;150m",
    color151: "\e[38;5;151m",
    color152: "\e[38;5;152m",
    color153: "\e[38;5;153m",
    color154: "\e[38;5;154m",
    color155: "\e[38;5;155m",
    color156: "\e[38;5;156m",
    color157: "\e[38;5;157m",
    color158: "\e[38;5;158m",
    color159: "\e[38;5;159m",
    color160: "\e[38;5;160m",
    color161: "\e[38;5;161m",
    color162: "\e[38;5;162m",
    color163: "\e[38;5;163m",
    color164: "\e[38;5;164m",
    color165: "\e[38;5;165m",
    color166: "\e[38;5;166m",
    color167: "\e[38;5;167m",
    color168: "\e[38;5;168m",
    color169: "\e[38;5;169m",
    color170: "\e[38;5;170m",
    color171: "\e[38;5;171m",
    color172: "\e[38;5;172m",
    color173: "\e[38;5;173m",
    color174: "\e[38;5;174m",
    color175: "\e[38;5;175m",
    color176: "\e[38;5;176m",
    color177: "\e[38;5;177m",
    color178: "\e[38;5;178m",
    color179: "\e[38;5;179m",
    color180: "\e[38;5;180m",
    color181: "\e[38;5;181m",
    color182: "\e[38;5;182m",
    color183: "\e[38;5;183m",
    color184: "\e[38;5;184m",
    color185: "\e[38;5;185m",
    color186: "\e[38;5;186m",
    color187: "\e[38;5;187m",
    color188: "\e[38;5;188m",
    color189: "\e[38;5;189m",
    color190: "\e[38;5;190m",
    color191: "\e[38;5;191m",
    color192: "\e[38;5;192m",
    color193: "\e[38;5;193m",
    color194: "\e[38;5;194m",
    color195: "\e[38;5;195m",
    color196: "\e[38;5;196m",
    color197: "\e[38;5;197m",
    color198: "\e[38;5;198m",
    color199: "\e[38;5;199m",
    color200: "\e[38;5;200m",
    color201: "\e[38;5;201m",
    color202: "\e[38;5;202m",
    color203: "\e[38;5;203m",
    color204: "\e[38;5;204m",
    color205: "\e[38;5;205m",
    color206: "\e[38;5;206m",
    color207: "\e[38;5;207m",
    color208: "\e[38;5;208m",
    color209: "\e[38;5;209m",
    color210: "\e[38;5;210m",
    color211: "\e[38;5;211m",
    color212: "\e[38;5;212m",
    color213: "\e[38;5;213m",
    color214: "\e[38;5;214m",
    color215: "\e[38;5;215m",
    color216: "\e[38;5;216m",
    color217: "\e[38;5;217m",
    color218: "\e[38;5;218m",
    color219: "\e[38;5;219m",
    color220: "\e[38;5;220m",
    color221: "\e[38;5;221m",
    color222: "\e[38;5;222m",
    color223: "\e[38;5;223m",
    color224: "\e[38;5;224m",
    color225: "\e[38;5;225m",
    color226: "\e[38;5;226m",
    color227: "\e[38;5;227m",
    color228: "\e[38;5;228m",
    color229: "\e[38;5;229m",
    color230: "\e[38;5;230m",
    color231: "\e[38;5;231m",
    color232: "\e[38;5;232m",
    color233: "\e[38;5;233m",
    color234: "\e[38;5;234m",
    color235: "\e[38;5;235m",
    color236: "\e[38;5;236m",
    color237: "\e[38;5;237m",
    color238: "\e[38;5;238m",
    color239: "\e[38;5;239m",
    color240: "\e[38;5;240m",
    color241: "\e[38;5;241m",
    color242: "\e[38;5;242m",
    color243: "\e[38;5;243m",
    color244: "\e[38;5;244m",
    color245: "\e[38;5;245m",
    color246: "\e[38;5;246m",
    color247: "\e[38;5;247m",
    color248: "\e[38;5;248m",
    color249: "\e[38;5;249m",
    color250: "\e[38;5;250m",
    color251: "\e[38;5;251m",
    color252: "\e[38;5;252m",
    color253: "\e[38;5;253m",
    color254: "\e[38;5;254m",
    color255: "\e[38;5;255m",
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
    orange: {255, 128, 0},
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

  defp _string_to_color(string)
  defp _string_to_color("#" <> bytes) do
    bytes
    |> String.codepoints()
    |> Enum.chunk_every(2)
    |> Enum.map(fn p -> with {r, ""} <- Integer.parse(p |> Enum.join(), 16), do: r end)
    |> List.to_tuple()
    |> rgb()
  end
  defp _string_to_color(string), do: string

  defp _transform(value)
  defp _transform(value) when is_number(value), do: "\e[#{value}m"
  defp _transform(value) when is_binary(value), do: _string_to_color(value)
  defp _transform(value) when is_tuple(value), do: rgb(value)
end

# SPDX-License-Identifier: Apache-2.0
