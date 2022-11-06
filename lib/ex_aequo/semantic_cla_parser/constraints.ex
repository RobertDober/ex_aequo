defmodule ExAequo.SemanticClaParser.Constraints do
  @moduledoc false

  def int?(value, key) do
    case Integer.parse(value) do
      {n, ""} -> {:ok, n}
      _ -> {:error, {:bad_constraint_int, key, value}}
    end
  end

  def int_range(from, to) do
    fn value, key ->
      case Integer.parse(value) do
        {n, ""} -> _in_range?(key, n, from, to)
        _ -> {:error, {:bad_constraint_int_range, key, value}}
      end
    end
  end

  defp _in_range?(key, value, from, to) do
    if Enum.member?(from..to, value) do
      {:ok, value}
    else
      {:error, {:not_in_int_range, key, value, from..to}}
    end
  end

end
# SPDX-License-Identifier: Apache-2.0
