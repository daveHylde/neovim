return {
  "seblj/roslyn.nvim",
  ft = { "cs" },
  config = function()
    -- Get rzls handlers and paths
    local rzls_handlers = require("rzls.roslyn_handlers")
    local rzls_path = vim.fn.expand("~/.local/share/nvim/mason/packages/rzls-unstable/libexec")

    -- Configure Roslyn LSP with rzls extension
    vim.lsp.config("roslyn", {
      cmd = {
        vim.fn.expand("~/.local/share/nvim/mason/bin/roslyn"),
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fn.stdpath("state"),
        "--stdio",
        -- rzls extension arguments
        "--razorSourceGenerator",
        vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        "--razorDesignTimePath",
        vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
        "--extension",
        vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
      },
      handlers = rzls_handlers,
      settings = {
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    })
  end,
}
