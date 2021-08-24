defmodule ExAequo.Error do
  @moduledoc false

  defexception [:message]

  @type t :: %__MODULE__{__exception__: true, message: String.t}

  @doc false
  @spec exception( String.t ) :: Exception.t
  def exception(msg), do: %__MODULE__{message: msg}
end
#  SPDX-License-Identifier: Apache-2.0
