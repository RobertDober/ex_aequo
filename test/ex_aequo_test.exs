defmodule Test.ExAequoTest do
  use ExUnit.Case

  doctest ExAequo, import: true

  @requested_format ~r{\A \d+ \. \d+ \. \d+ \z}x
  test "version string" do
    assert Regex.match?(@requested_format, ExAequo.version())
  end
end
