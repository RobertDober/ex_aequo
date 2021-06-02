defmodule ExAequo.SysInterface.Mock.Expectations do
  alias Support.Dlist

  def start_link do
    Agent.start_link(fn -> Dlist.new end, name: __MODULE__)
  end

  def clear do
    Agent.update(__MODULE__, fn _ -> Dlist.new end)
  end

  def invocation_of(fun, spec \\ [])
  def invocation_of(fun, spec) do
    args1 = Keyword.get(spec, :with, [])
    return = Keyword.get(spec, :returns, nil)
    Agent.update(__MODULE__, &Dlist.push(&1, {fun, args1, return}))
    return
  end

  def check_invocation_of(fun, with: args) do
    Agent.get_and_update(__MODULE__, &check_invocation_of!(&1, fun, args))
  end

  defp check_invocation_of!(expectations, fun, args) do
    {expectation, next_expectations} = Dlist.pop(expectations)
    case expectation do
      {^fun, ^args, result} -> {result, next_expectations}
      _ -> raise "Cannot match invocation of #{fun}, with: #{inspect args}, expectation is: #{inspect expectation}"
    end
  end

end
