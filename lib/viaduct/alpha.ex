defmodule Alpha do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @impl GenServer
  def init(_opts) do
    {:ok, 0}
  end

  @impl GenServer
  def handle_call(request, from, counter)

  def handle_call(:counter, _from, counter) do
    {:reply, counter, counter + 1}
  end

  def counter do
    GenServer.call(__MODULE__, :counter)
  end
end
