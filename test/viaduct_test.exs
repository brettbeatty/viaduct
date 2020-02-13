defmodule ViaductTest do
  use ExUnit.Case
  doctest Viaduct

  test "greets the world" do
    assert Viaduct.hello() == :world
  end
end
