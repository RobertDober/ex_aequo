defmodule ExAequo.Error do
  @moduledoc false

  defexception [:message]
  
  @doc false
  @spec exception( String.t ) :: Exception.t
  def exception(msg), do: %__MODULE__{message: msg}
end
