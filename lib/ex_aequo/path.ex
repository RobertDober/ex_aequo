defmodule ExAequo.Path do
  use ExAequo.Types

  @moduledoc """
  Extending Elixir's Path module with some useful functions
  """

  @doc """
  ```elxir
      iex(0)> base_name_without_ext("a/b/c.txt")
      "c"

      iex(1)> base_name_without_ext("a/b/c.txt.eex")
      "c.txt"

      iex(2)> base_name_without_ext("a/b/c")
      "c"
  ```
  """
  @spec base_name_without_ext(String.t) :: String.t
  def base_name_without_ext(filename) do
    ext = Path.extname(filename)
    filename |> Path.basename(ext)
  end
  @doc """
  ```elxir
      iex(3)> full_name_without_ext("a/b/c.txt")
      "a/b/c"

      iex(4)> full_name_without_ext("a/b/c.txt.eex")
      "a/b/c.txt"

      iex(5)> full_name_without_ext("a/b/c")
      "a/b/c"

      iex(6)> full_name_without_ext("/c")
      "/c"
  ```
  """
  @spec full_name_without_ext(String.t) :: String.t
  def full_name_without_ext(filename) do
    ext = Path.extname(filename)
    rgx = Regex.compile!( Regex.escape(ext) <> "\\z" )
    Regex.replace(rgx, filename, "")
  end

end
