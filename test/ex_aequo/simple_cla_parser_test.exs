defmodule Test.ExAequo.SimpleClaParserTest do
  use ExUnit.Case

  doctest ExAequo.SimpleClaParser, import: true

  import ExAequo.SimpleClaParser, only: [parse: 1]

  describe "nada" do
    test "niente se preferisci" do
      assert parse([]) == result([])
    end
  end

  describe "flags" do
    test "just one" do
      assert parse(~W[:one]) == result(one: true)
    end
    test "mehrere" do
      assert parse(~W[:one :two]) == result(one: true, two: true)
    end
  end

  defp result(kwds, args \\ []), do: {:ok, %{args: args, kwds: kwds |> Enum.into(%{})}}
end
# SPDX-License-Identifier: Apache-2.0
