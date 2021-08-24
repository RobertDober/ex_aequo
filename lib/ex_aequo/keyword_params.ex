defmodule ExAequo.KeywordParams do
  
  use ExAequo.Types

  @moduledoc """
  ## Tools to facilitate dispatching on keyword parameters, used in contexts like the following

        @defaults [a: 1, b: false] # Keyword or Map
        def some_fun(..., options \\ []) # options again can be a Keyword or Map
          {a: a, b: b} = extract_params(@defaults, options, [:a, :b])

  ### Merging defaults and actual parameters
  
  Its most useful feature is that you will get a map whatever the mixtures of maps and keywords the
  input was

      iex(0)> merge_params([])
      %{}

      iex(0)> merge_params([a: 1], %{b: 2})
      %{a: 1, b: 2}

  """
end
