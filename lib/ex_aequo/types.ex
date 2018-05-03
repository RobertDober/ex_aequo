defmodule ExAequo.Types do
  
  defmacro __using__( _options) do
    quote do
      @type lstat_result :: {:ok, File.Stat.t()} | {:error, File.posix()}
    end
  end
end
