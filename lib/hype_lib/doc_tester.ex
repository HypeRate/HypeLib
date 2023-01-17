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
    use HypeLib.DocTester, [MyModule]
  end
  ```

  would result in the following `MyTest` module:

  ```elixir
  defmodule MyTest do
    use ExUnit.Case

    doctest MyModule
  end
  ```

  which then can be run by ExUnit.

  In this example ExUnit would run the `add/2` test where the expected result is 3.
  """

  defmacro __using__(modules) do
    mapped_modules =
      modules
      |> Enum.map(fn module_to_test ->
        quote do
          doctest unquote(module_to_test)
        end
      end)

    [
      quote do
        use ExUnit.Case
      end
    ] ++ mapped_modules
  end
end
