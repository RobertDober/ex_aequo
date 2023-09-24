defmodule ExAequo.Fn do
  @moduledoc ~S"""
  Functional helpers
  """

  @doc ~S"""
  A functional wrapper for nil
      
      iex(1)> nil_fn()
      nil

      iex(2)> nil_fn(42)
      nil

      iex(3)> nil_fn({:a, :b}, "hello")
      nil

      iex(4)> nil_fn([], "hello", %{})
      nil
  """
  def nil_fn, do: nil
  def nil_fn(_), do: nil
  def nil_fn(_, _), do: nil
  def nil_fn(_, _, _), do: nil

end
# SPDX-License-Identifier: Apache-2.0
