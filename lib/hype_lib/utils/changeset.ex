defmodule HypeLib.Utils.Changeset do
  @moduledoc """
  ## Changelog

  ### 2.3.0

  First implementation

  ### 2.3.1

  Fixed credo warnings

  ### <upcoming version>

  Added the initial implementation of the `validate_not_nil/2` function
  """

  import Ecto.Changeset

  alias HypeLib.Utils

  @doc """
  If the underlying struct contains a non-nil value for the given field, then
  the function will generate a new random string and puts it into the changeset.

  The `charset` argument should be generated through the `HypeLib.Utils.String.Generator.charsets/1`
  or `HypeLib.Utils.String.Generator.charsets!/1` functions.

  ## Changelog

  ### 2.3.0

  First implementation

  ### 2.3.2

  Added the `charset` argument. This gives developers more control over the used characters
  which should be used when generating the random string.
  """
  def put_generated_string_if_needed(
        %Ecto.Changeset{} = changeset,
        field,
        charset,
        generated_string_length \\ 32
      ) do
    case get_field(changeset, field) do
      nil ->
        generated_string =
          Utils.String.Generator.generate_string!(generated_string_length, charset)

        put_change(changeset, field, generated_string)

      _ ->
        changeset
    end
  end

  @doc """
  Validates if the given field / list of fields are not nil.

  When the changeset contains a field whose value is nil, then the field will
  be removed from the changeset and an field specific error will be appended to
  the changeset.

  ## Credits

  ## Changelog

  ### <upcoming version>

  Initial implementation
  """
  def validate_not_nil(changeset, field_or_fields) when is_list(field_or_fields) do
    Enum.reduce(field_or_fields, changeset, fn field, changeset ->
      if get_field(changeset, field) == nil do
        add_error(changeset, field, "nil")
      else
        changeset
      end
    end)
  end

  def validate_not_nil(changeset, field_or_fields) when is_atom(field_or_fields),
    do: validate_not_nil(changeset, [field_or_fields])
end
