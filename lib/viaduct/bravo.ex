defmodule Viaduct.Bravo do
  use GenServer
  alias Viaduct.Alpha

  @opt_keys [:registry]

  def start_link(opts \\ []) do
    {bravo_opts, gen_server_opts} = Keyword.split(opts, @opt_keys)
    GenServer.start_link(__MODULE__, bravo_opts, gen_server_opts)
  end

  @impl GenServer
  def init(opts) do
    {:ok, %{alpha: alpha_name(opts)}}
  end

  defp alpha_name(opts) do
    case Keyword.fetch(opts, :registry) do
      {:ok, registry} ->
        {:via, Registry, {registry, Alpha}}

      :error ->
        Alpha
    end
  end

  @impl GenServer
  def handle_call(request, from, state)

  def handle_call({:get, key}, _from, state) do
    case state do
      %{^key => value} ->
        {:reply, value, state}

      _ ->
        value = Alpha.counter(state.alpha)
        {:reply, value, Map.put(state, key, value)}
    end
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end
end
