defmodule HypeLib.DocTester do
  @moduledoc """
  A utility module for efficiently generating `doctest` directives

  ## Examples

  The following example

  ```elixir
  defmodule MyModule do
    @doc \"\"\"
    A function that calculates the summary of two numbers

    ## Examples

    iex> MyModule.add(1, 2)
    3
    \"\"\"
    def add(a, b), do: a + b
  end

  defmodule MyTest do
    use HypeLib.DocTester, modules: [MyModule]
  end
  ```

  would result in the following `MyTest` module:

  ```elixir
  defmodule MyTest do
    use ExUnit.Case, async: true

    doctest MyModule
  end
  ```

  which then can be run by ExUnit.

  In this example ExUnit would run the `add/2` test where the expected result is 3.

  ## Expected options

  | Name    | Expected data type | Description                                                |
  | :------ | :----------------- | :--------------------------------------------------------- |
  | modules | `list(module())`   | A list of modules to generate the `doctest` directives for |
  | async   | `boolean()`        | Gets passed down to the `use ExUnit.Case` call             |

  ## Changelog

  ### 0.0.1

  Initial implementation

  ### 2.0.0

  Refactor to use a Keyword list as first argument instead of list of modules.

  Added support for the `modules` and `async` option.
  Added documentation about the expected options.
  """

  defmacro __using__(args) do
    modules = Keyword.get(args, :modules, [])
    is_async = Keyword.get(args, :async, true)

    exunit_prelude =
      if is_async do
        quote do
          use ExUnit.Case, async: true
        end
      else
        quote do
          use ExUnit.Case
        end
      end

    mapped_modules =
      Enum.map(modules, fn module_to_test ->
        quote do
          doctest unquote(module_to_test)
        end
      end)

    [
      exunit_prelude
    ] ++ mapped_modules
  end
end
