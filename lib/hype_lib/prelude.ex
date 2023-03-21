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

  ## Changelog

  ### 1.0.0

  Initial release
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

  ## Changelog

  ### 1.0.0

  Initial release
  """
  def string do
    quote do
      # credo:disable-for-next-line
      alias HypeLib.Utils.String, as: StringUtils
    end
  end

  @spec! url() :: Macro.t()
  @doc """
  ## Changelog

  ### <upcoming version>
  """
  def url do
    quote do
      # credo:disable-for-next-line
      alias HypeLib.Utils.Url, as: UrlUtils
    end
  end

  @spec! entity() :: Macro.t()
  @doc """
  Imports the Ecto schema functions and all changeset functions

  ## Usage

  This macro adds an module attribute to the calling module for defining
  ecto timestamps as `DateTime` structs instead of `NaiveDateTime`.

  Hint: Do not forget to configure your application to use timestamps with timezone information:

  ```elixir
  config :my_app,
      MyApp.Repo,
      migration_timestamps: [
        type: :utc_datetime
      ]
  ```

  You might want to install [Timex](https://hexdocs.pm/timex) for DateTime convenience functions
  like creating and manipulating the date or time.

  Run the following command to view the latest version of Timex:

  ```
  mix hex.info timex
  ```

  ## Changelog

  ### 2.2.0

  - Added the `Database` alias
  - Added timezone support
  - Added the `Usage` section


  ### 1.0.0

  Initial release
  """
  def entity do
    quote do
      use Ecto.Schema

      # credo:disable-for-next-line
      alias Ecto.Schema, as: Database

      import Ecto.Changeset

      @timestamps_opts [type: :utc_datetime]
    end
  end

  @spec! graphql() :: Macro.t()
  @doc """
  Imports the Absinthe notation module

  ## Changelog

  ### 2.2.0

  - Added the `GraphQL` alias

  ### 1.0.0

  Initial release
  """
  def graphql do
    quote do
      use Absinthe.Schema.Notation
      # credo:disable-for-next-line
      alias Absinthe.Schema.Notation, as: GraphQL
    end
  end

  @spec! graphql_schema() :: Macro.t()
  @doc """
  Imports the graphql AST and uses the `Absinthe.Schema`

  ## Changelog

  ### 2.2.0

  Initial release
  """
  def graphql_schema do
    [
      graphql(),
      quote do
        use Absinthe.Schema
      end
    ]
  end
end
