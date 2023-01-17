defmodule HypeLibTest do
  use HypeLib.DocTester, [
    HypeLib.Prelude,
    HypeLib.UseInvoker,
    HypeLib.Utils.String.Generator
  ]
end
