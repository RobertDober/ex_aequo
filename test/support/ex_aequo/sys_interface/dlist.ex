defmodule Support.Dlist do
  defstruct next: 0, elements: %{}, popped: 0

  def new(elements \\ %{}, next \\ 0, popped \\ 0) do
    %__MODULE__{elements: elements, next: next, popped: popped}
  end

  def empty?(dlist), do: dlist.next == dlist.popped

  def pop(dlist)
  def pop(dlist) do
    if empty?(dlist) do
      raise "Error pop from empty dlist"
    else
      pop!(dlist)
    end
  end

  def push(%{elements: elements, next: n, popped: p}, value) do
    new(Map.put(elements, n, value), n + 1, p)
  end


  defp pop!(%{next: n, popped: p, elements: elements}) do
    {element, new_elements} = Map.get_and_update(elements, p, fn _ -> :pop end)
    {element, new(new_elements, n, p + 1)}
  end
end
