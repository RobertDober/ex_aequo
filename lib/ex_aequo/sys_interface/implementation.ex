defmodule ExAequo.SysInterface.Implementation do
  use ExAequo.Types

  @behaviour ExAequo.SysInterface.Behavior
  
  @spec expand_path( Path.t() ) :: binary()
  def expand_path path do
    Path.expand(path)
  end

  @spec lstat( Path.t(), File.stat_options() ) :: lstat_result()
  def lstat path, options \\ [] do
    File.lstat(path, options)
  end

  @spec wildcard( Path.t(), keyword() ) :: [binary()]
  def wildcard path, options \\ [] do
    Path.wildcard(path, options)
  end
end
