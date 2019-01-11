defmodule ExAequo.SysInterface.Mock.Expectations do

  defstruct expectations: []

  def new, do: %__MODULE__{}

  def add_expectation expectations, fun, args, return do
    [{fun, args, return} | expectations]
  end

  def check_invocation_of(expectations, fun, args \\ [])
  def check_invocation_of(expectations, fun, with: args) do
    case expectations do
      [{^fun, ^args, result} | rest] -> {result, rest}
      _ -> raise "Cannot match invocation of #{fun}, with: #{inspect args}, expectations are:\n\t#{inspect expectations}"
    end
  end
  def check_invocation_of(expectations, fun, _), do: check_invocation_of(expectations, fun, with: [])

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
