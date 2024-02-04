defmodule ExAequo.File.Names do

  @moduledoc ~S"""
    Tool to manipulate file names
  """

  @doc ~S"""

  ### `assure_ext` assures that a given extension is added if not yet present

    iex(1)> assure_ext("hello.ex", "ex")
    "hello.ex"

    iex(2)> assure_ext("hello", "ex")
    "hello.ex"

    iex(3)> assure_ext("some_dir/hello", "ex")
    "some_dir/hello.ex"

    iex(4)> assure_ext("hello.html", "eex")
    "hello.html.eex"
  """
  def assure_ext(path, extension) do
    if String.ends_with?(path, "." <> extension) do
      path
    else
      path <> "." <> extension
    end
  end

  @doc ~S"""
  ### `remove_ext` assures that a given extension is removed if present
  
    iex(0)> remove_ext("a.rb", "rb")
    "a"
  
    iex(0)> remove_ext("d/a.ex", "rb")
    "d/a.ex"
  """
  def remove_ext(path, extension) do
    if String.ends_with?(path, "." <> extension) do
      String.replace(path, "." <> extension, "")
    else
      path
    end
  end

  @doc ~S"""

  ### `replace_ext` assures that a given extension replaces the last extension

    iex(5)> replace_ext("hello.ex", "ex")
    "hello.ex"

    iex(6)> replace_ext("hello.rb", "ex")
    "hello.ex"

    iex(7)> replace_ext("hello.html.erb", "eex")
    "hello.html.eex"

    iex(8)> replace_ext("dir/base", "ex")
    "dir/base.ex"

  """
  @last_extension_rgx ~r{ (?: \. [^.]* )? \z }x
  def replace_ext(path, extension) do
    if String.ends_with?(path, "." <> extension) do
      path
    else 
      String.replace(path, @last_extension_rgx, "." <> extension, global: false)
    end
  end
    
end
# SPDX-License-Identifier: Apache-2.0
