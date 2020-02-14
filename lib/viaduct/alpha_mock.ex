defmodule Viaduct.AlphaMock do
  use GenServer

  @opt_keys [:owner]

  def start_link(opts \\ []) do
    {alpha_mock_opts, gen_server_opts} = Keyword.split(opts, @opt_keys)
    GenServer.start_link(__MODULE__, alpha_mock_opts, gen_server_opts)
  end

  @impl GenServer
  def init(opts) do
    {:ok, %{owner: opts[:owner], counter: 0}}
  end

  @impl GenServer
  def handle_call(request, from, state)

  def handle_call(:counter, _from, state) do
    send(state.owner, {:counter, state.counter})
    {:reply, state.counter, %{state | counter: state.counter + 1}}
  end

  @impl GenServer
  def handle_cast(request, state)

  def handle_cast({:put, counter}, state) do
    {:noreply, %{state | counter: counter}}
  end

  def put(alpha_mock, counter) do
    GenServer.cast(alpha_mock, {:put, counter})
  end
end
