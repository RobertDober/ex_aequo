defmodule ExAequo.Mixfile do
  use Mix.Project

  @modulename "ExAequo"
  @description """
  Some Tools Commonly Needed (commonly means once a year by me, but still)
  """
  @url "https://github.com/robertdober/ex_aequo"
  @version "0.2.0"
  def project do
    [
     aliases: [docs: &build_docs/1],
     app: :ex_aequo,
     deps: deps(),
     description: @description,
     elixir: "~> 1.12",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     package:       package(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test],
     version: @version,
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: []]
  end


  defp package do
    [
      files:       [ "lib", "mix.exs", "README.md", "LICENSE" ],
      maintainers: [
                     "Robert Dober <robert.dober@gmail.com>"
                   ],
      licenses:    [ "Apache 2 (see the file LICENSE)" ],
      links:       %{
                       "GitHub" => "https://github.com/RobertDober/ex_aequo",
                   }
    ]
  end

  defp deps do
    [
      {:extractly, "~>0.3.0", only: :dev},
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.14.2", only: :test},
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  @prerequisites """
  run `mix escript.install hex ex_doc` and adjust `PATH` accordingly
  """
  defp build_docs(_) do
    Mix.Task.run("compile")
    ex_doc = Path.join(Mix.path_for(:escripts), "ex_doc")
    Mix.shell().info("Using escript: #{ex_doc} to build the docs")

    unless File.exists?(ex_doc) do
      raise "cannot build docs because escript for ex_doc is not installed, make sure to \n#{@prerequisites}"
    end

    args = [@modulename, @version, Mix.Project.compile_path()]
    opts = ~w[--main #{@modulename} --source-ref v#{@version} --source-url #{@url}]

    Mix.shell().info("Running: #{ex_doc} #{inspect(args ++ opts)}")
    System.cmd(ex_doc, args ++ opts)
    Mix.shell().info("Docs built successfully")
  end

end

# SPDX-License-Identifier: Apache-2.0
