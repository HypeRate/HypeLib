defmodule HypeLibTest do
  @moduledoc """
  ## Changelog

  ### <upcoming version>

  Added the `HypeLib.Utils.Url` module to the modules to run DocTests for
  """

  use HypeLib.DocTester,
    modules: [
      HypeLib.Prelude,
      HypeLib.UseInvoker,
      HypeLib.Utils.String.Generator,
      HypeLib.Utils.Url
    ]
end
