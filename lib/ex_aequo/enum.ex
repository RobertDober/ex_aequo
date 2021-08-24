defmodule ExAequo.Enum do
  alias ExAequo.Error


  @moduledoc """
  ## ExAequo.Enum offers some extension functions for Elixir's Enum module
  
  ### Grouped Accumulation

  Groupes accumulated values of an Enum according to a function that
  indicates if two consequent items are of the same kind and if so
  how to accumulate their two values.

  The `grouped_reduce` function returns the groupes in reverse order, as,
  during traversal of lists quite often reversing the result of the 
  classical "take first and push a function of it to the result" pattern
  cancels out.
  
  An optional, `reverse: true` keyword option can be provided to reverse
  the final result for convenience.

        iex(0)> add_same = fn {x, a}, {y, b} ->
        ...(0)>               cond do
        ...(0)>                 x == y -> {:cont, {x, a + b}}
        ...(0)>                 true   -> {:stop, nil} end end
        ...(0)> E.grouped_reduce(
        ...(0)>   [{:a, 1}, {:a, 2}, {:b, 3}, {:b, 4}], add_same)
        [{:b, 7}, {:a, 3}]

  The `grouped_inject` function behaves almost identically to `grouped_reduce`,
  however an initial value is provided.

        iex(1)> sub_same = fn {x, a}, {y, b} -> 
        ...(1)>               cond do
        ...(1)>                 x == y -> {:cont, {x, a - b}}
        ...(1)>                 true   -> {:stop, nil}
        ...(1)>               end
        ...(1)>            end
        ...(1)> E.grouped_inject(
        ...(1)> [{:a, 1}, {:b, 2}, {:b, 2}, {:c, 2}, {:c, 1}, {:c, 1}],
        ...(1)>  {:a, 43}, sub_same, reverse: true)
        [a: 42, b: 0, c: 0]
  """

  @type grouped_accumulator(ele_type, result_type) :: (ele_type , ele_type -> {:cont | :stop, result_type})

  @doc false
  @spec grouped_reduce( list(ele_type), grouped_accumulator(ele_type, result_type), Keyword.t )
    :: list(result_type) when ele_type: any(), result_type: any()
  def grouped_reduce(xs, gacc_fn, options \\ [])
  def grouped_reduce([], _, _), do: []
  def grouped_reduce([x|xs], f, options) do
    if options[:reverse] do
      grouped_acc_impl(xs, x, f, []) |> Enum.reverse()
    else
      grouped_acc_impl(xs, x, f, []) 
    end
  end

  @doc false
  @spec grouped_inject( list(ele_type), ele_type, grouped_accumulator(ele_type, result_type), Keyword.t )
    :: list(result_type) when ele_type: any(), result_type: any()
  def grouped_inject(xs, initial, gacc_fn, options \\ [])
  def grouped_inject(xs, initial, f, options) do
    if options[:reverse] do
      grouped_acc_impl(xs, initial, f, []) |> Enum.reverse()
    else
      grouped_acc_impl(xs, initial, f, [])
    end
  end

  @spec grouped_acc_impl( list(ele_type), ele_type, grouped_accumulator(ele_type, result_type), Keyword.t )
    :: list(result_type) when ele_type: any(), result_type: any()
  defp grouped_acc_impl(xs, acc, f, result)
  defp grouped_acc_impl([], acc, _, result), do: [acc|result]
  defp grouped_acc_impl([x|xs], acc, f, result) do
    case f.(acc, x) do
      {:cont, combination} -> grouped_acc_impl(xs, combination, f, result)
      {:stop, _}           -> grouped_acc_impl(xs, x,           f, [acc|result])
      _                    -> raise Error, "function must be of type {:cont, any()} | {:stop, any()}"
    end
  end

end
