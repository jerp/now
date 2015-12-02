defmodule Now.Mixfile do
  use Mix.Project

  def project do
    [
      app: :now,
      version: "0.0.1",
      elixir: "~> 1.0",
      erlc_options: erlc_options,
      description: "Simulate portability of erlang:now/0 to v18",
      package: package,
      deps: deps(Mix.env),
      docs: &docs/0,
    ]
  end

  defp deps(:prod), do: []
  # Returns the list of dependencies for docs
  defp deps(:docs) do
    deps(:prod) ++
      [
        {:ex_doc, ">= 0.0.0" },
        {:earmark, ">= 0.0.0"}
      ]
  end
  defp deps(_), do: deps(:prod)

  defp docs do
    [
      source_ref: System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])|>elem(0),
    ]
  end

  def erlc_options do
    extra_options = try do
      case :erlang.list_to_integer(:erlang.system_info(:otp_release)) do
        v when v >= 18 ->
          [{:d, :time_correction}]
        _ ->
          []
      end
    catch
      _ ->
        []
    end
    [:debug_info, :warnings_as_errors | extra_options]
  end


  defp package do
    [ maintainers: ["jerp"],
      licenses: ["MIT"],
      files: ~w(src rebar.config README.md),
      links: %{
        "GitHub" => "https://github.com/checkiz/now",
        "Documentation" => "http://hexdocs.pm/now"
      } ]
   end
end
