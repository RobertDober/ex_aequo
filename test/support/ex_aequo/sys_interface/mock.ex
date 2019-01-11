defmodule ExAequo.SysInterface.Mock do
  @behaviour ExAequo.SysInterface.Behavior

  alias ExAequo.SysInterface.Mock.Expectations

  def start_link do
    Agent.start_link(fn -> Expectations.new end, name: __MODULE__)
  end

  def clear do
    Agent.update(__MODULE__, fn _ -> Expectations.new end)
  end

  def debug_state do
    Agent.get(__MODULE__, &(&1))
  end

  def messages do
    Agent.get(__MODULE__, &(&1.messages))
  end

  def invocation_of(fun, args, return \\ nil)
  def invocation_of(fun, args, _) when is_list(args) do
    args1 = Keyword.get(args, :with, [])
    return = Keyword.get(args, :returns, nil)
    Agent.update(__MODULE__, &Expectations.add_expectation(&1, fun, args1, return))
  end
  def invocation_of(fun, args, return) do
    Agent.update(__MODULE__, &Expectations.add_expectation(&1, fun, args, return))
  end

  def expand_path path do
    Agent.get_and_update(__MODULE__, &Expectations.check_invocation_of(&1, :expand_path, with: path))
  end

  def lstat path, options \\ [] do
    File.lstat(path, options)
  end

  def wildcard path, options \\ [] do
    Path.wildcard(path, options)
  end
  
end
