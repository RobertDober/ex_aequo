defmodule ExAequo.File do
  use ExAequo.Types

  @moduledoc """
  ## ExAequo.File

  """

  @doc """

  read a file into lines

      iex(0)> readlines(Path.join(~W[test fixtures a_simple_file.txt]))
      ["Line 1", "Line two", " Una terza linea"]
  """
  def readlines(segments)
  def readlines(segments) when is_binary(segments) do
    readlines([segments])
  end
  def readlines(segments) do
    segments
    |> Path.join
    |> File.stream!
    |> Enum.map(&String.trim_trailing(&1, "\n"))
  end



  @doc """
  expands `wc` and zips each matching file into a list of `{String.t, File.Stat.t}`, then
  filters only the files from today
  """
  @spec today(String.t) :: Enumerable.t
  def today wc do
    wc
    |> files_with_stat()
    |> Stream.filter(&is_today?/1)
  end


  @doc """
  """
  @spec files(String.t) :: [String.t]
  def files wc do
    with abs_path <- sys_interface().expand_path(wc) do
      abs_path
      |> sys_interface().wildcard()
    end
  end

  @doc """
  expands `wc` and zips each matching file into a list of `{String.t, File.Stat.t}`
  """
  @spec files_with_stat(String.t) :: Enumerable.t
  def files_with_stat wc do
    with abs_path <- sys_interface().expand_path(wc) do
      abs_path
      |> Path.wildcard()
      |> Stream.map(&({ &1, ok_lstat(&1) }))
    end
  end


  @spec is_today?({any(), %{mtime: {date_tuple(), tuple()}}}) :: boolean()
  defp is_today? file_tuple do
    with {_, %{mtime: {date, _}}} <- file_tuple, do: date == today_tuple()
  end

  @spec ok_lstat(String.t) :: File.Stat.t
  defp ok_lstat file do
    with {:ok, lstat} <- File.lstat(file), do: lstat
  end

  @spec sys_interface() :: module()
  defp sys_interface do
    Application.fetch_env!(:ex_aequo, :sys_interface)
  end

  @spec today_tuple() :: date_tuple()
  defp today_tuple do
    with {date, _time} <- :calendar.local_time(), do: date
  end
end
