defmodule Mix.Tasks.DefaultTask do
  use Mix.Task

  @shortdoc "Default project tasks"

  def run(_) do
    Mix.Task.run "credo"
    Mix.Task.run "test"
  end
end
