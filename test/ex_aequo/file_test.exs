defmodule ExAequo.FileTest do
  use ExUnit.Case, async: false
  alias ExAequo.File

  test "correct behavior of #files" do
    @sys_interface.invocation_of(:expand_path, with: [42], returns: ~W[alpha beta])
    assert @sys_interface.expand_path(42) == ~W[alpha beta]

  end


  @local_files %{"hello" => {:ok,
    %::File.Stat{
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
