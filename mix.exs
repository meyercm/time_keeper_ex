defmodule TimeKeeper.MixProject do
  use Mix.Project

  def project do
    [
      app: :time_keeper,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TimeKeeper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:shorter_maps, "~> 2.2"},
      {:flub, "~> 1.1"},
      {:predicate_sigil, "~> 0.1"},
      {:pattern_tap, "~> 0.4"},
    ]
  end
end
