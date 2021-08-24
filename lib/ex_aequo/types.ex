defmodule ExAequo.Types do
  
  defmacro __using__( _options) do
    quote do
      @type date_tuple :: {non_neg_integer(), 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12, 1..255}
      @type lstat_result :: {:ok, File.Stat.t()} | {:error, File.posix()}
      @type param_type :: Keyword.t | map()
    end
  end
end
