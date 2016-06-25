%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      checks: [
        {Credo.Check.Readability.ModuleDoc,   false},
        {Credo.Check.Refactor.PipeChainStart, false}
      ]
    }
  ]
}
