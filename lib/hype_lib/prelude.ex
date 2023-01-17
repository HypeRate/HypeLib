defmodule HypeLib.Prelude do
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

  @spec! entity() :: Macro.t()
  @doc """
  Imports the Ecto schema functions and all changeset functions
  """
  def entity do
    quote do
      use Ecto.Schema

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
    end
  end
end
