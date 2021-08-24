defmodule ExAequo.Kernel do
  defmacro pp(left, right) do
    [{h, _} | t] = Macro.unpipe({:|>, [], [left, right]}) |> IO.inspect

    fun = fn {x, pos}, acc ->
      Macro.pipe(acc, x, pos)
    end

    :lists.foldl(fun, h, t)
  end
end
