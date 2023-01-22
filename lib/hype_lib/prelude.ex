defmodule HypeLib.Prelude do
  @moduledoc """
  The `Prelude` module contains utility functions for working with
  external dependencies like TypeCheck, the Elixir `Logger` moudle etc.
  """

  use TypeCheck
  use HypeLib.UseInvoker, required_utils: [:core]

  @spec! core() :: Macro.t()
  @doc """
  Imports TypeCheck and requires the Erlang logger
  """
  def core do
    quote do
      use TypeCheck

      require Logger
    end
  end

  @spec! string() :: Macro.t()
  @doc """
  Imports the `HypeLib.Utils.String` module as `StringUtils` into the current context.

  ## Examples

  ```elixir
  iex> defmodule TokenGenerator do
  ...>   use HypeLib.Prelude, :string
  ...>
  ...>   @spec! generate_token() :: String.t()
  ...>   def generate_token() do
  ...>     StringUtils.Generator.generate_string!(1, ~w(a))
  ...>   end
  ...> end
  ...>
  ...> TokenGenerator.generate_token()
  "a"
  ```
  """
  def string do
    quote do
      # credo:disable-for-next-line
      alias HypeLib.Utils.String, as: StringUtils
    end
  end

  @spec! entity() :: Macro.t()
  @doc """
  Imports the Ecto schema functions and all changeset functions
  """
  def entity do
    quote do
      use Ecto.Schema

      # credo:disable-for-next-line
      alias Ecto.Schema, as: Database

      import Ecto.Changeset
    end
  end

  @spec! graphql() :: Macro.t()
  @doc """
  Imports the Absinthe notation module
  """
  def graphql do
    quote do
      use Absinthe.Schema.Notation
      # credo:disable-for-next-line
      alias Absinthe.Schema.Notation, as: GraphQL
    end
  end
end
