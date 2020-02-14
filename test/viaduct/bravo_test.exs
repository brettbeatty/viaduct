defmodule Viaduct.BravoTest do
  use ExUnit.Case, async: true
  alias Viaduct.{Alpha, AlphaMock, Bravo}

  @registry __MODULE__.Registry
  @alpha_name {:via, Registry, {@registry, Alpha}}

  setup do
    {:ok, _registry} = Registry.start_link(name: @registry, keys: :unique)
    {:ok, alpha_mock} = AlphaMock.start_link(name: @alpha_name, owner: self())
    {:ok, _bravo} = Bravo.start_link(name: Bravo, registry: @registry)

    [alpha_mock: alpha_mock]
  end

  describe "get/1" do
    test "increments values sequentically" do
      assert [Bravo.get(:a), Bravo.get(:b), Bravo.get(:c)] == [0, 1, 2]
    end

    test "tracks values for keys" do
      assert [Bravo.get(:d), Bravo.get(:e), Bravo.get(:d)] == [0, 1, 0]
    end

    test "starts where Alpha starts", %{alpha_mock: alpha_mock} do
      AlphaMock.put(alpha_mock, 15)

      assert [Bravo.get(:e), Bravo.get(:f)] == [15, 16]
    end

    test "uses Alpha to increment" do
      refute_received {:counter, 0}
      Bravo.get(:g)
      assert_received {:counter, 0}

      refute_received {:counter, 1}
      Bravo.get(:h)
      assert_received {:counter, 1}

      refute_received {:counter, 2}
      Bravo.get(:i)
      assert_received {:counter, 2}
    end
  end
end
