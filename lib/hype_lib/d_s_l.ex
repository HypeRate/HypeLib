defmodule HypeLib.DSL do
  @moduledoc """
  The `HypeLib.DSL` module contains functions for parsing custom Domain-specific languages (DSLs).

  ## Changelog

  ### 2.3.1

  Fixed credo warnings
  """

  use HypeLib.Prelude

  alias HypeLib.DSL.Parser

  @spec! parse(
           parser_module :: Parser.t(),
           ast_to_parse :: Parser.ast_element()
         ) :: Parser.parse_result()
  def parse(parser_module, ast_to_parse) do
    Parser.check_parser_module(parser_module)

    initial_parser_state = Parser.get_initial_state(parser_module)

    parse(parser_module, initial_parser_state, ast_to_parse)
  end

  @spec! parse!(
           parser_module :: Parser.t(),
           ast_to_parse :: Parser.ast_element()
         ) :: Parser.state()
  def parse!(parser_module, ast_to_parse) do
    parse_result = parse(parser_module, ast_to_parse)
    parser_result_to_state(parse_result)
  end

  @spec! parse(
           parser_module :: Parser.t(),
           initial_parser_state :: Parser.state(),
           ast_to_parse :: Parser.ast_element()
         ) :: Parser.parse_result()
  def parse(parser_module, initial_parser_state, ast_to_parse) do
    Parser.check_parser_module(parser_module)

    ast_to_parse
    |> Macro.prewalk(initial_parser_state, &parser_module.on_node/2)
    |> finish_parsing(parser_module)
  end

  @spec! parse!(
           parser_module :: Parser.t(),
           initial_parser_state :: Parser.state(),
           ast_to_parse :: Parser.ast_element()
         ) :: Parser.state()
  def parse!(parser_module, initial_parser_state, ast_to_parse) do
    parse_result = parse(parser_module, initial_parser_state, ast_to_parse)
    parser_result_to_state(parse_result)
  end

  defp finish_parsing({walked_ast, walked_state}, parser_module) do
    if function_exported?(parser_module, :on_finish, 2) do
      parser_module.on_finish(walked_ast, walked_state)
    else
      {walked_ast, walked_state}
    end
  end

  defp parser_result_to_state({_ast, parser_state}), do: parser_state
end
