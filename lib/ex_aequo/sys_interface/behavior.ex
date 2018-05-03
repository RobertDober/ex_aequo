defmodule ExAequo.SysInterface.Behavior do
  use ExAequo.Types
  
  @callback expand_path(Path.t()) :: binary()
  @callback lstat(Path.t(), File.stat_options()) :: lstat_result()
  @callback wildcard(Path.t(), keyword()) :: [binary()]
end
