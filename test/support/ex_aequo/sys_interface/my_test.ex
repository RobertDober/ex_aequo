defmodule Support.MyTest do
  defmacro __using__(_\\[]) do
    quote do
      use ExUnit.Case, async: false
      import unquote(__MODULE__), only: [double: 1]
    end
  end

  def double(name) do
    [name, "_",
      Integer.to_string(:rand.uniform(4294967296), 32),
      Integer.to_string(:rand.uniform(4294967296), 32) ]
      |> Enum.join
  end
end
