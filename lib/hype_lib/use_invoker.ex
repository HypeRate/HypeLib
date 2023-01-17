defmodule HypeLib.UseInvoker do
  @moduledoc """
  The `HypeLib.UseInvoker` module offers a use macro for utility modules.

  The macro defines a `__using__` macro in the **CALLING MODULE** where the first argument is
  expected to be an atom so we can pass it directly to the `apply/3` function as second argument.

  The macro supports the following options:

  > **Name:**
  >
  > required_utils
  >
  > **Expected data type:**
  >
  > list(atom)
  >
  > **Description:**
  >
  > A list of function names (atoms) which should always be invoked when
  > the macro is called.


  ## Examples

  ### Without any arguments

  ```elixir
  iex> defmodule MyUtils do
  ...>   use HypeLib.UseInvoker
  ...>
  ...>   def num() do
  ...>     quote do
  ...>       def add(a, b), do: a + b
  ...>     end
  ...>   end
  ...> end
  ...>
  ...> defmodule MyConsumer do
  ...>   use MyUtils, :num
  ...>
  ...>   def my_add(a, b), do: add(a, b)
  ...> end
  ...>
  ...> MyConsumer.my_add(1, 2)
  3
  ```

  ### With required_utils

  ```elixir
  iex> defmodule MyUtils do
  ...>   use HypeLib.UseInvoker, required_utils: [:core]
  ...>
  ...>   def core do
  ...>     quote do
  ...>       def core_fun(), do: "core function"
  ...>     end
  ...>   end
  ...>
  ...>   def num() do
  ...>     quote do
  ...>       def add(a, b), do: a + b
  ...>     end
  ...>   end
  ...> end
  ...>
  ...> defmodule MyConsumer do
  ...>   use MyUtils, :num
  ...> end
  ...>
  ...> MyConsumer.core_fun()
  "core function"
  ```

  """

  defmacro __using__(args) do
    required_utils = Keyword.get(args, :required_utils, [])

    quote do
      use TypeCheck

      @spec __using__(which :: atom() | list(atom())) :: Macro.t()
      defmacro __using__(which) when is_atom(which) do
        apply_using([which])
      end

      defmacro __using__(which) when is_list(which) do
        apply_using(which)
      end

      defp apply_using(which) do
        unquote(required_utils)
        |> Kernel.++(which)
        |> Enum.uniq()
        |> Enum.map(&apply(__MODULE__, &1, []))
      end
    end
  end
end
