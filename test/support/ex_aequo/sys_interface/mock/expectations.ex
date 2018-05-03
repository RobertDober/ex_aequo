defmodule ExAequo.SysInterface.Mock.Expectations do

  defstruct messages: [],
  results: %{expand_path: []}

  def new, do: %__MODULE__{}

  def add_expectation exp, fun, will_return do
    %{exp |
        results: %{exp.results |
                    fun => [ will_return | Map.get(exp.results, fun, []) ] } }
  end

  def get_path exp, path do
    case Map.fetch!(exp.results, :expand_path) |> List.pop_at(0) do
      {nil, _} -> raise "Unexpected invocation of :expand_path"
      {result, rest} -> {result, update(exp, :expand_path, [path], rest)}
    end
  end

  defp update exp, invocation, args, rest_results do
    %{exp |
        messages: [{invocation, args} | exp.messages],
        results: %{exp.results| invocation => [rest_results]}}
  end

end 
