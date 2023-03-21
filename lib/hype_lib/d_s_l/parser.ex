defmodule HypeLib.DSL.Parser do
  use HypeLib.Prelude

  # Type definitions

  @type! t() :: module()

  @type! state() :: term()

  @type! ast_element() :: term()

  @type! parse_result() :: {ast_element(), state()}

  # Callbacks

  @callback on_init() :: state()

  @callback on_node(element :: ast_element(), parser_state :: state()) :: parse_result()

  @callback on_finish(element :: ast_element(), parser_state :: state()) :: parse_result()

  @optional_callbacks on_init: 0, on_finish: 2

  # region `use` macro

  defmacro __using__(_args) do
    quote do
      alias HypeLib.DSL.Parser

      @behaviour Parser
    end
  end

  # Helper functions

  @doc """
  Returns the initial state of the parser
  """
  def get_initial_state(parser_module), do: apply(parser_module, :on_init, [])

  @spec! is_parser(module_to_check :: term()) :: boolean
  def is_parser(module_to_check) do
    try do
      check_parser_module(module_to_check)

      true
    catch
      _ ->
        false
    end
  end

  @spec! check_parser_module(module_to_check :: term()) :: nil | none()
  def check_parser_module(module_to_check) do
    unless is_atom(module_to_check) do
      raise __MODULE__.Error.NoModuleError, module_to_check
    end

    unless is_module(module_to_check) do
      raise __MODULE__.Error.NoModuleError, module_to_check
    end

    unless has_on_node(module_to_check) do
      raise __MODULE__.Error.MissingLifecycleMethodError, {module_to_check, :on_node, 2}
    end
  end

  def unhandled_element(element, parser_state) do
    IO.puts("-------- UNHANDLED AST ELEMENT --------")
    IO.puts("Found undhandled element:")
    IO.inspect(element)
    IO.puts("")
    IO.puts("At state:")
    IO.inspect(parser_state)
    IO.puts("---------------------------------------")

    {element, parser_state}
  end

  defp is_module(module_to_check), do: function_exported?(module_to_check, :__info__, 1)

  defp has_on_node(module_to_check), do: function_exported?(module_to_check, :on_node, 2)
end
