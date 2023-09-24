defmodule ExAequo.Fn do
  @moduledoc ~S"""
  Functional helpers
  """

  @doc ~S"""
  Ignoring args, returning a const 

      iex(1)> const_fn(1).()
      1

      iex(2)> const_fn(2, 1)
      2

      iex(3)> const_fn(:a, 1, 2)
      :a

      iex(4)> const_fn(nil, 1, :a, [])
      nil

  """
  def const_fn(const), do: fn -> const end
  def const_fn(const, _), do: const
  def const_fn(const, _, _), do: const
  def const_fn(const, _, _, _), do: const

  @doc ~S"""
  A functional wrapper for nil
      
      iex(5)> nil_fn()
      nil

      iex(6)> nil_fn(42)
      nil

      iex(7)> nil_fn({:a, :b}, "hello")
      nil

      iex(8)> nil_fn([], "hello", %{})
      nil
  """
  def nil_fn, do: nil
  def nil_fn(_), do: nil
  def nil_fn(_, _), do: nil
  def nil_fn(_, _, _), do: nil

  @doc ~S"""

      iex(9)> tagged_fn(:alpha).("beta")
      {:alpha, "beta"}

  """
  def tagged_fn(tag) do
    fn x -> {tag, x} end
  end
end
# SPDX-License-Identifier: Apache-2.0
