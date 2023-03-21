defmodule HypeLib.DSL.Parser.Error do
  @moduledoc """
  A parent module which contains submodules for exceptions that could occur when parsing an AST

  ## Changelog

  ### 2.3.1

  Fixed credo warnings
  """

  defmodule NoModuleError do
    defexception [:message]

    @impl Exception
    def exception(value),
      do: %__MODULE__{
        message: "value '#{inspect(value)}' is not a module"
      }
  end

  defmodule MissingLifecycleMethodError do
    defexception [:module, :function_name, :arity]

    @impl Exception
    def exception({module, function_name, arity}),
      do: %__MODULE__{
        module: module,
        function_name: function_name,
        arity: arity
      }

    @impl Exception
    def message(%__MODULE__{module: module, function_name: function_name, arity: arity}),
      do: """
      The given module '#{inspect(module)}' does not implement the required HypeLib.DSL.Parser `#{function_name}/#{arity}` lifecycle method
      """
  end
end
