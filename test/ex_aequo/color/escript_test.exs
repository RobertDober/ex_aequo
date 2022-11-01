defmodule Test.ExAequo.Color.EscriptTest do
  use ExUnit.Case 

  import ExAequo.Color.Escript, only: [main: 1]
  import ExUnit.CaptureIO

  test "-l without step" do
    output = capture_io(:stdio, fn ->
      main(~W[-l 10..20 145..155 80])
    end)
    assert output == "\e[38;2;10;145;80m{10, 145, 80}\e[0m\n"
  end

  test "-l with step" do
    output = capture_io(:stdio, fn ->
      main(~W[-l 10..20 145..155 80 10])
    end)
    assert output == "\e[38;2;10;145;80m{10, 145, 80}\e[0m\n\e[38;2;10;155;80m{10, 155, 80}\e[0m\n\e[38;2;20;145;80m{20, 145, 80}\e[0m\n\e[38;2;20;155;80m{20, 155, 80}\e[0m\n"
  end

  test "--list without step" do
    output = capture_io(:stdio, fn ->
      main(~W[--list 10..20 145..165 80])
    end)
    assert output == "\e[38;2;10;145;80m{10, 145, 80}\e[0m\n\e[38;2;10;165;80m{10, 165, 80}\e[0m\n"
  end

  test "--list with step" do
    output = capture_io(:stdio, fn ->
      main(~W[--list 10..20 145..165 80 20])
    end)
    assert output == "\e[38;2;10;145;80m{10, 145, 80}\e[0m\n\e[38;2;10;165;80m{10, 165, 80}\e[0m\n"
  end

  test "other" do
    output = capture_io(:stdio, fn ->
      main(~W[:orange Clockwork 10,20,30 Hello :reset])
    end)
    assert output == "\e[38;2;255;128;0mClockwork\e[38;2;10;20;30mHello\e[0m\e[0m\n"
  end
end
# SPDX-License-Identifier: Apache-2.0
