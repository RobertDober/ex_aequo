defmodule Test.ExAequo.Color.ColorizerTest do
  use ExUnit.Case

  import ExAequo.Color, only: [colorize: 1]

  describe "some doctests" do
    test "bad name" do
      colorize("\\.red\\.hello.reset.world")
    end
  end
  
end
# SPDX-License-Identifier: Apache-2.0
