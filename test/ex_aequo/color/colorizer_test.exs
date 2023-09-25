defmodule Test.ExAequo.Color.ColorizerTest do
  use ExUnit.Case

  import ExAequo.Color, only: [colorize: 1]

  describe "some doctests" do
    test "bad name" do
      assert colorize("\\.red\\.hello<reset>world") == ".red.hello\e[0mworld"
    end
  end

  describe "non-regressions" do
    test "version info" do
      assert colorize("version: <cyan>0.6.1 (2023-09-25)") == "version: \e[36m0.6.1 (2023-09-25)"
    end

    test "concise multicolors" do
      assert colorize("<red,bold>hello") == "\e[31m\e[1mhello"
    end

  end
end
# SPDX-License-Identifier: Apache-2.0
