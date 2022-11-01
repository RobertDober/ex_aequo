defmodule ExAequo.Color do
  @moduledoc ~S"""

    ## Support for the 256 ANSI and full RGB colors

    **N.B.** Does, of course, respect the usage of the `$NO_COLOR` variable

    The most basic approach is to use the generated escape sequences directly in your code, e.g.

    ```elixir
      IO.puts(ExAequo.Color.rgb(250, 148, 13) <> "Brownish Orange" <> ExAequo.Color.reset)
    ```

    The generated escape codes would be:

      iex(0)> rgb(250, 148, 13)
      "\e[38;2;250;148;13m"

      iex(1)> reset()
      "\e[0m"
  """

  def reset, do: "\e[0m"

  def rgb(red, green, blue), do: "\e[38;2;#{red};#{green};#{blue}m"

  def rgb({red, green, blue}), do: rgb(red, green, blue)
end

# SPDX-License-Identifier: Apache-2.0
