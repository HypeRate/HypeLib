defmodule HypeLib.Utils.Changeset do
  alias HypeLib.Utils

  import Ecto.Changeset

  @doc """
  ## Changelog

  ### 2.3.0

  First implementation
  """
  def put_generated_string_if_needed(
        %Ecto.Changeset{} = changeset,
        field,
        generated_string_length \\ 32
      ) do
    case get_field(changeset, field) do
      nil ->
        charsets = Utils.String.Generator.charsets!([:lower_hex])

        generated_string =
          Utils.String.Generator.generate_string!(generated_string_length, charsets)

        put_change(changeset, field, generated_string)

      _ ->
        changeset
    end
  end
end
