defmodule HypeLibTest do
  use HypeLib.DocTester,
    modules: [
      HypeLib.Prelude,
      HypeLib.UseInvoker,
      HypeLib.Utils.String.Generator
    ]
end
