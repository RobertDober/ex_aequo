defmodule ExAequo.CLToolsTest do
  use ExUnit.Case

  alias ExAequo.SysInterface.Mock
  alias ExAequo.CLTools

  test "correct behavior of #files" do 
    Mock.clear

    Mock.invocation_of :expand_path, "some_dir" 
    CLTools.files "~/hello"

    assert Mock.messages() == [{:expand_path, ["~/hello"]}]
    
  end
end
