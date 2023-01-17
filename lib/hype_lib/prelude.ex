defmodule HypeLib.Prelude do
  use TypeCheck

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

  @spec! __using__(which :: atom() | list(atom())) :: Macro.t()
  defmacro __using__(which) when is_atom(which) do
    apply_using([which])
  end

  defmacro __using__(which) when is_list(which) do
    apply_using(which)
  end

  defp apply_using(which) do
    which =
      if Enum.member?(which, :core) do
        which
      else
        [:core] ++ which
      end

    Enum.reduce(
      which,
      quote do
      end,
      fn entry, acc ->
        quote do
          unquote(acc)
          unquote(apply(HypeLib.Prelude, entry, []))
        end
      end
    )
  end
end
