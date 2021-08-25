defmodule ExAequo.Path do
  use ExAequo.Types

  @moduledoc """
  Extending Elixir's Path module with some useful functions
  """

  @doc """
      iex(0)> basename_without_ext("a/b/c.txt")
      "c"

      iex(1)> basename_without_ext("a/b/c.txt.eex")
      "c.txt"

      iex(2)> basename_without_ext("a/b/c")
      "c"
  """
  @spec basename_without_ext(String.t) :: String.t
  def basename_without_ext(filename) do
    ext = Path.extname(filename)
    filename |> Path.basename(ext)
  end
  @doc """
      iex(3)> fullname_without_ext("a/b/c.txt")
      "a/b/c"

      iex(4)> fullname_without_ext("a/b/c.txt.eex")
      "a/b/c.txt"

      iex(5)> fullname_without_ext("a/b/c")
      "a/b/c"

      iex(6)> fullname_without_ext("/c")
      "/c"
  """
  @spec fullname_without_ext(String.t) :: String.t
  def fullname_without_ext(filename) do
    ext = Path.extname(filename)
    rgx = Regex.compile!( Regex.escape(ext) <> "\\z" )
    Regex.replace(rgx, filename, "")
  end

end
