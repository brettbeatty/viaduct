defmodule Bravo do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @impl GenServer
  def init(_opts) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call(request, from, state)

  def handle_call({:get, key}, _from, state) do
    case state do
      %{^key => value} ->
        {:reply, value, state}

      _ ->
        value = Alpha.counter()
        {:reply, value, Map.put(state, key, value)}
    end
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end
end
