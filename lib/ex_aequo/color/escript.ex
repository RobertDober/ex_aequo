defmodule ExAequo.Color.Escript do
  import ExAequo.Color, only: [puts: 1, puts: 2]

  def main(args)
  def main(["-v" | _]), do: _version()
  def main(["--version" | _]), do: _version()

  def main(["-h" | _]), do: _help()
  def main(["--help" | _]), do: _help()

  def main([]) do
    IO.read(:stdio, :eof) |> puts()
  end

  def main(args) do
    args
    |> Enum.join(" ")
    |> puts()
  end

  @help_text ~S"""
  <cyan>Synopsis:<reset>

  <italic,bold>colorize<reset>: Colorize standard input with <italic>ExAequo.Color.colorize/1

     <dim,uline>Example:<reset> 

       The first line of this help text was specified as follows:

       \<italic,bold\>colorize\<reset>: Colorize standard input with \<italic>ExAequo.Color.colorize/1

  <cyan>Usage:<reset>

  <bold>colorize<reset><green> -h|--help<reset>    . . . shows this text
  <bold>colorize<reset><green> -v|--version<reset> . . . shows version and release date 

  <bold>colorize<reset><green> options<reset>  . . . . . colorizes standard input with the aforementioned syntax<reset>
       <green>options<reset> not implemented yet only the defaults are available for now
       <green>--open<reset> how to start a color name, defaults to <cyan,bold>"\<"<reset>
       <green>--close<reset> how to end a color name, defaults to <cyan,bold>">"<reset>
       <green>--sep<reset> how to seperate color names, defaults to <cyan,bold>","<reset>
       <green>--escape<reset> how to escape the <green>open<reset> char, defaults to <cyan,bold>"\\"<reset>
  """
  defp _help do
    puts(@help_text)
  end

  defp _env(key), do: Application.fetch_env!(:ex_aequo, key)

  defp _version do
    version_info =
      "version: <cyan>#{_env(:version)} <reset>(<green>#{_env(:release_date)}<reset>)"
    puts(version_info)
  end
end

# SPDX-License-Identifier: Apache-2.0
