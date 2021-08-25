defmodule ExAequo do
  @moduledoc """
  Namespace only and exposing version
  """

  @doc """
  Used by the `xtra` mix task to generate the latest version in the docs, but
  also handy for client applications for quick exploration in `iex`.
  """
  @spec version() :: binary()
  def version() do
    with {:ok, version} = :application.get_key(:ex_aequo, :vsn),
      do: to_string(version)
  end

end
#  SPDX-License-Identifier: Apache-2.0
