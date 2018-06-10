defmodule ExAequo.Structures.List do
  
  @spec reverse( list(any()) ) :: list(any()) 
  def reverse( x ), do: reverse1 x, []

  @spec reverse1( list(any()), list(any()) ) :: list(any())
  defp reverse1 x, y
  defp reverse1 [], y do
    IO.puts "[], #{inspect y}"
    y
  end
  defp reverse1 [x|xs], y do
    IO.puts "#{inspect [x|xs]}, #{inspect y}"
    reverse1 xs, [x|y]
  end
end
