defmodule HypeLib.Utils.String.Generator do
  @moduledoc """
  Contains utility functions for generating a random string and creating charsets.

  It offers the following interesting functions:
  - `HypeLib.Utils.String.Generator.charset/1` - obtain a charset based on the given name
  - `HypeLib.Utils.String.Generator.charsets!/1` - generate one big charset based on the given names
  - `HypeLib.Utils.String.Generator.generate_string!/3` - generate a random string based on the given charset

  The `charset/1` function uses the `valid_charsets()` type for returning a predefined charset.
  """

  use HypeLib.Prelude

  @typedoc """
  Defines the union type of known charset names.

  | Charset name (atom) | Description                               |
  | :------------------ | :---------------------------------------- |
  | `:lower`            | The lowercased alphabet (a-z)             |
  | `:upper`            | The uppercased alphabet (A-Z)             |
  | `:numeric`          | All numerical values (0-9)                |
  | `:hex`              | All hexadecimal values in uppercase (0-F) |
  | `:lower_hex`        | All hexadecimal values in lowercase (0-f) |
  | `:upper_hex`        | All hexadecimal values in uppercase (0-F) |
  """
  @type! valid_charsets() :: :lower | :upper | :numeric | :hex | :lower_hex | :upper_hex

  @spec! charset(name :: valid_charsets()) :: list(String.t())
  @doc """
  Returns a charset based on the given name

  ## Examples

  ### Lowercased alphabet

  ```elixir
  iex> HypeLib.Utils.String.Generator.charset(:lower)
  ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
  ```

  ### Uppercased alphabet

  ```elixir
  iex> HypeLib.Utils.String.Generator.charset(:upper)
  ~w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
  ```

  ### Numerical characters

  ```elixir
  iex> HypeLib.Utils.String.Generator.charset(:numeric)
  ~w(0 1 2 3 4 5 6 7 8 9)
  ```

  ### Hexadecimal characters

  ```elixir
  iex> HypeLib.Utils.String.Generator.charset(:hex)
  ~w(0 1 2 3 4 5 6 7 8 9 A B C D E F)
  ```

  ```elixir
  iex> HypeLib.Utils.String.Generator.charset(:upper_hex)
  ~w(0 1 2 3 4 5 6 7 8 9 A B C D E F)
  ```

  ```elixir
  iex> HypeLib.Utils.String.Generator.charset(:lower_hex)
  ~w(0 1 2 3 4 5 6 7 8 9 a b c d e f)
  ```
  """
  def charset(:lower), do: ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z)

  def charset(:upper), do: ~w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

  def charset(:numeric), do: ~w(0 1 2 3 4 5 6 7 8 9)

  def charset(:hex), do: charset(:numeric) ++ ~w(A B C D E F)

  def charset(:lower_hex), do: charset(:numeric) ++ ~w(a b c d e f)

  def charset(:upper_hex), do: charset(:hex)

  @spec! charsets(charset_names :: list(valid_charsets())) ::
           {:ok, list(String.t())} | {:error, String.t()}
  @doc """
  Combines the given charset names to one big charset

  ## Examples

  It should return an error tuple when the given charset names are empty

  ```elixir
  iex> HypeLib.Utils.String.Generator.charsets([])
  {:error, "Empty charset names list provided"}
  ```

  It should return a combination of the lowercased alphabet and
  numerical numbers when the charset names are `[:lower, :numeric]`

  ```elixir
  iex> alias HypeLib.Utils.String.Generator
  ...> Generator.charsets([:lower, :numeric])
  {:ok, Generator.charset(:lower) ++ Generator.charset(:numeric)}
  ```

  It should return an combination of the lower- and uppercased alphabet
  including numerical characters when the charset names are `[:lower, :upper, :numeric]`

  ```elixir
  iex> alias HypeLib.Utils.String.Generator
  ...> Generator.charsets([:lower, :upper, :numeric])
  {:ok, Generator.charset(:lower) ++ Generator.charset(:upper) ++ Generator.charset(:numeric)}
  ```
  """
  def charsets([]), do: {:error, "Empty charset names list provided"}

  def charsets(charset_names) do
    mapped_charset =
      charset_names
      |> Enum.uniq()
      |> Enum.flat_map(&apply(__MODULE__, :charset, [&1]))

    {:ok, mapped_charset}
  end

  @spec! charsets!(charset_names :: list(valid_charsets())) ::
           list(String.t()) | none()
  @doc """
  Tries to generate one big charset based on the given charset names.

  When the charset can't be generated then an error will be raised.
  This could happen in the following cases:
  - the given list is empty
  - the given list contains invalid charset names (via TypeCheck runtime check) (see `Expected arguments` section)

  ## Expected arguments

  | Name          | Expected data type       | Description                   | Example values                             |
  | :------------ | :----------------------- | :---------------------------- | :----------------------------------------- |
  | charset_names | `list(valid_charsets())` | A list of valid charset names | `[:lower]`, `~w(lower upper numeric hex)a` |

  ## Examples

  ```elixir
  iex> HypeLib.Utils.String.Generator.charsets!(~w(lower numeric)a)
  ~w(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9)
  ```

  ```elixir
  iex> HypeLib.Utils.String.Generator.charsets!([])
  ** (RuntimeError) Empty charset names list provided
  ```
  """
  def charsets!(charset_names) do
    case charsets(charset_names) do
      {:ok, result} ->
        result

      {:error, error} ->
        raise error
    end
  end

  @spec! generate_string(
           desired_length :: pos_integer(),
           charset :: list(String.t())
         ) :: {:ok, String.t()} | {:error, String.t()}

  @spec! generate_string(
           desired_length :: pos_integer(),
           charset :: list(String.t()),
           current_string :: String.t()
         ) :: {:ok, String.t()} | {:error, String.t()}
  @doc """
  Generates a string of the desired length with random characters from the given charset.

  ## Examples

  It should return an error when the given charset is empty

  ```elixir
  iex> HypeLib.Utils.String.Generator.generate_string(2, [])
  {:error, "Invalid charset length"}
  ```

  Generate a string with a length of 2 and a given charset of ~w(a)

  ```elixir
  iex> HypeLib.Utils.String.Generator.generate_string(2, ~w(a))
  {:ok, "aa"}
  ```

  Generate a random string with a length of 16 and the alphabet given as charset

  ```elixir
  iex> alias HypeLib.Utils.String.Generator
  ...> {:ok, result} = Generator.generate_string(16, Generator.charset(:lower))
  ...> String.length(result)
  16
  ```

  It returns the current string if it has already the desired length

  ```elixir
  iex> alias HypeLib.Utils.String.Generator
  ...> Generator.generate_string(1, Generator.charset(:lower), "a")
  {:ok, "a"}
  ```

  It returns the current string if it is already longer than the desired length

  ```elixir
  iex> alias HypeLib.Utils.String.Generator
  ...> Generator.generate_string(1, Generator.charset(:lower), "aa")
  {:ok, "aa"}
  ```
  """
  def generate_string(desired_length, charset, current_string \\ "")

  def generate_string(_desired_length, [], _current_string),
    do: {:error, "Invalid charset length"}

  def generate_string(desired_length, charset, current_string) do
    if String.length(current_string) >= desired_length do
      {:ok, current_string}
    else
      generate_string(desired_length, charset, current_string <> Enum.random(charset))
    end
  end

  @spec! generate_string!(
           desired_length :: pos_integer(),
           charset :: list(String.t())
         ) :: String.t() | none()

  @spec! generate_string!(
           desired_length :: pos_integer(),
           charset :: list(String.t()),
           current_string :: String.t()
         ) :: String.t() | none()
  @doc """
  Generates a string of the desired length and given charset.

  Hint 1: You can use these functions to quickly generate a charset:
  - `HypeLib.Utils.String.Generator.charset/1`
  - `HypeLib.Utils.String.Generator.charsets!/1`

  Hint 2: We don't provide any charsets for special characters since this is highly application specific.

  When the string can't be generated then an error will be raised.
  This could happen in the following cases:
  - the given charset is an empty list
  - the arguments don't match the expected types (via TypeCheck runtime check) (see `Expected arguments` section)

  ## Expected arguments

  | Name           | Expected data type   | Description                                                          | Example values       |
  | :------------- | :------------------- | :------------------------------------------------------------------- | :------------------- |
  | desired_length | `number()`           | Only positive numerical values (excluding zero and negative numbers) | `0`, `3.14`          |
  | charset        | `list(String.t())`   | A list of strings which will be randomly picked                      | `["a"]`, `~w(a b c)` |
  | current_string | `String.t()`         | The starting string                                                  | `""`, `"a"`, `"aAa"` |

  ## Examples

  It should raise an runtime error when the charset is an empty list.

  ```elixir
  iex> HypeLib.Utils.String.Generator.generate_string!(2, [])
  ** (RuntimeError) Invalid charset length
  ```

  Generate a string with a length of 2 and a given charset of ~w(a)

  ```elixir
  iex> HypeLib.Utils.String.Generator.generate_string!(2, ~w(a))
  "aa"
  ```

  Generate a random string with a length of 16 and the alphabet given as charset

  ```elixir
  iex> alias HypeLib.Utils.String.Generator
  ...> Generator.generate_string!(16, Generator.charset(:lower))
  ...> |> String.length()
  16
  ```

  It returns the current string if it has already the desired length

  ```elixir
  iex> alias HypeLib.Utils.String.Generator
  ...> Generator.generate_string!(1, Generator.charset(:lower), "a")
  "a"
  ```

  It returns the current string if it is already longer than the desired length

  ```elixir
  iex> alias HypeLib.Utils.String.Generator
  ...> Generator.generate_string!(1, Generator.charset(:lower), "aa")
  "aa"

  """
  def generate_string!(desired_length, charset, current_string \\ "") do
    case(generate_string(desired_length, charset, current_string)) do
      {:ok, result} ->
        result

      {:error, error} ->
        raise error
    end
  end
end
