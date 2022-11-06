defmodule ExAequo.SemanticClaParser.Description do
  alias ExAequo.SemanticClaParser.Constraints

  @moduledoc false

  defstruct constraints: [], needed: 0..99, optional: [], required: []

  def new(description), do: struct(__MODULE__, description)

  def validate(%__MODULE__{}=desc, args) do 
    args
    |> Map.put(:errors, [])
    |> _validate_needed(desc.needed)
    |> _validate_required(desc.required)
    |> _validate_optional(desc.optional)
    |> _validate_constraints(desc.constraints)
    |> _wrap_result()
  end

  defp _semantic_check_arg(cla, pos, desc, value)
  defp _semantic_check_arg(cla, pos, predefined, value) when is_atom(predefined) do
    _semantic_check_arg(cla, pos, &apply(Constraints, "#{predefined}?" |> String.to_atom, [&1, &2]), value) 
  end
  defp _semantic_check_arg(%{args: args, errors: errors}=cla, pos, fun, value) when is_function(fun) do
    case fun.(value, pos) do
      {:ok, new_value} -> %{cla | args: List.replace_at(args, pos - 1, new_value)}
      {:error, message} -> %{cla | errors: [message | errors]} 
    end
  end

  defp _semantic_check_kwd(args, kwd, value, type)
  defp _semantic_check_kwd(args, kwd, value, predefined) when is_atom(predefined) do
    _semantic_check_kwd(args, kwd, value, &apply(Constraints, "#{predefined}?" |> String.to_atom, [&1, &2]))
  end
  defp _semantic_check_kwd(%{kwds: kwds, errors: errors}=args, kwd, value, fun) when is_function(fun) do
    case fun.(value, kwd) do
      {:ok, value} -> %{ args | kwds: Map.put(kwds, kwd, value) }
      {:error, message} -> %{ args | errors: [message | errors] } 
    end
  end

  defp _validate_constraints(args, _constraints) do
    args
  end

  defp _validate_needed(args, needed)
  defp _validate_needed(args, needed) when is_number(needed), do: _validate_needed(args, needed..needed)
  defp _validate_needed(args, %Range{}=needed) do
    if Enum.member?(needed, Enum.count(args.args)) do
      args
    else
      %{args | errors: [{:illegal_number_of_args, needed, Enum.count(args.args)}|args.errors]}
    end
  end

  defp _validate_optional(args, optional) do
    optional 
    |> Enum.reduce(args, &_validate_optional_kwd/2)
  end

  defp _validate_optional_arg({pos, desc}, %{args: args}=cla) do
    case Enum.at(args, pos) do
      nil -> cla
      val -> _semantic_check_arg(cla, pos, desc, val)
    end
  end

  defp _validate_optional_kwd(optional_kwd, args)
  defp _validate_optional_kwd({pos, value}, args) when is_number(pos), do: _validate_optional_arg({pos, value}, args)
  defp _validate_optional_kwd({rq_kwd, type}, args) do
    case Map.fetch(args.kwds, rq_kwd) do
      :error -> args
      {:ok, value} -> _semantic_check_kwd(args, rq_kwd, value, type)
    end
  end

  defp _validate_required(args, required) do
    required 
    |> Enum.reduce(args, &_validate_required_kwd/2)
  end

  defp _validate_required_kwd(required_kwd, args)
  defp _validate_required_kwd(required_kwd, args) when is_atom(required_kwd), do: _validate_required_kwd({required_kwd, true}, args)
  defp _validate_required_kwd({rq_kwd, type}, args) do
    case Map.fetch(args.kwds, rq_kwd) do
      :error -> %{args | errors: [{:missing_required_kwd, rq_kwd}|args.errors]}
      {:ok, value} -> _semantic_check_kwd(args, rq_kwd, value, type)
    end
  end

  defp _wrap_result(args)
  defp _wrap_result(%{errors: []}=args), do: {:ok, Map.delete(args, :errors)}
  defp _wrap_result(args), do: {:error, args}


end
# SPDX-License-Identifier: Apache-2.0
