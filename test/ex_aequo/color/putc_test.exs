defmodule Test.ExAequo.Color.PutcTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import ExAequo.Color, only: [putc: 1]

  test "an example" do
    expected = "hello\e[32mworld\e[0m--\e[38;5;13mcolor13\e[38;2;255;0;255mFUCHSIA\n"
    actual = capture_io(:stdio, fn ->
      putc(["hello", :green, "world", :reset, "--", :color13, "color13", :fuchsia, "FUCHSIA"])
    end)

    assert actual == expected
  end

end
# SPDX-License-Identifier: Apache-2.0
