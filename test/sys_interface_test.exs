defmodule SysInterfaceTest do
  use ExUnit.Case
  alias ExAequo.SysInterface.Mock

  test "correct return val" do
    Mock.clear

    Mock.invocation_of :expand_path, 43 

    assert Mock.expand_path(:alpha) == 43
  end
end
