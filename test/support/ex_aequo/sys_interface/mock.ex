defmodule ExAequo.SysInterface.Mock do
  @behaviour ExAequo.SysInterface.Behavior

  import ExAequo.SysInterface.Mock.Expectations, only: [check_invocation_of: 2]

  def expand_path path do
    check_invocation_of(:expand_path, with: [path])
  end

  def lstat path, options \\ [] do
    check_invocation_of(:lstat, with: [path, options])
  end

  def wildcard path, _options \\ [] do
    check_invocation_of(:wildcard, with: [path])
  end

end
