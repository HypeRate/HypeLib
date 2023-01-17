defmodule HypeLib do
  @moduledoc """
  `HypeLib` is the internal Elixir framework of HypeRate which is
  used across all Elixir related repositories.

  ## Examples

  ### Prelude

  The `HypeLib` library contains a "prelude" module for saving code when
  it comes to importing frequently used modules.

  For example would a simple "use" call import TypeCheck and require the Erlang logger.

  ```elixir
  defmodule MyModule do
    use HypeLib.Prelude

    # Use TypeCheck for runtime-based type checks
    #
    # The `add` function will be wrapped around a special function
    # which checks if both arguments (a and b) are numbers (an integer or float).
    # It also checks if the returned value is of type number.
    @spec! add(a :: number(), b :: number()) :: number()
    def add(a, b), do: a + b
  end
  ```
  """
end
