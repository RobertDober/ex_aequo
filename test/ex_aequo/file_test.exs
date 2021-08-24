defmodule ExAequo.FileTest do
  use Support.MyTestHelper
  alias ExAequo.File, as: F

  import ExAequo.SysInterface.Mock.Expectations, only: [invocation_of: 2]
  test "correct behavior of #files" do
    path = double("path")
    expanded = invocation_of(:expand_path, with: [path], returns: double("expanded"))
    elements = invocation_of(:wildcard, with: [expanded], returns: double("elements"))
    assert F.files(path) == elements
  end

  test "today" do
    expanded = invocation_of(:expand_path, with: ["*"], returns: double("expanded"))
    assert F.today("*") |> Enum.to_list |> Enum.empty?
  end

  @local_files %{"hello" => {:ok,
    %File.Stat{
      access: :read_write,
      atime: {{2018, 5, 26}, {12, 2, 56}},
      ctime: {{2018, 4, 18}, {14, 58, 36}},
      gid: 1000,
      inode: 923418, 
      links: 1,
      major_device: 2049,
      minor_device: 0,
      mode: 33204,
      mtime: {{2018, 4, 18}, {14, 57, 8}},
      size: 40,
      type: :regular,
      uid: 1000
    }}
  }
  defp local_lstat filename do
    Map.get @local_files, filename
  end
end
