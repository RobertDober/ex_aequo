defmodule ExAequo.CLTools do

  @sys_interface Application.fetch_env!(:ex_aequo, :sys_interface)

  @moduledoc """
  ## ExAequo Command Line Tools

  ### File Filter
  """


  @doc """
  expands `wc` and zips each matching file into a list of `{String.t, File.Stat.t}`, then
  filters only the files from today
  """
  def today wc do
    wc
    |> files()
    |> Stream.filter(&is_today?/1)
  end


  @doc """
  expands `wc` and zips each matching file into a list of `{String.t, File.Stat.t}`
  """
  def files wc do
    with abs_path <- @sys_interface.expand_path(wc) do
      abs_path
      |> Path.wildcard()
      |> Stream.map(&({ &1, ok_lstat(&1) }))
    end
  end


  defp is_today? file_tuple do
    with {_, %{mtime: {date, _}}} <- file_tuple, do: date == today_tuple()
  end

  defp ok_lstat file do
    with {:ok, lstat} <- File.lstat(file), do: lstat
  end

  defp today_tuple do
    with {date, _time} <- :calendar.local_time(), do: date
  end
  
end
