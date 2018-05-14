defmodule TimeKeeper.MouseWatcher do
  use GenServer
  import ShorterMaps

  # TODO: figure out a better mocking strategy.
  @process Process
  @position_provider TimeKeeper.PositionProvider

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_current_position() do
    GenServer.call(__MODULE__, :get_current_position)
  end

  def jitter() do
    GenServer.cast(__MODULE__, :jitter)
  end

  defmodule State do
    @moduledoc false
    defstruct [
      current_position: nil,
      interval_ms: 1_000,
    ]
  end

  ######################
  # GenServer Callbacks
  ######################

  def init([]) do
    ~M{%State interval_ms} = state = %State{}
    check_position(interval_ms)
    {:ok, state}
  end

  def handle_call(:get_current_position, _from, ~M{current_position} = state) do
    {:reply, current_position, state}
  end

  def handle_call(:active?, _from, ~M{active} = state) do
    {:reply, active, state}
  end

  def handle_cast(:jitter, %{current_position: ~M{x, y}} = state) do
    @position_provider.set_position(1, 1)
    @position_provider.set_position(x, y)
    {:noreply, state}
  end
  def handle_cast(:jitter, state) do
    {:noreply, state}
  end

  def handle_info(:check_position, ~M{interval_ms} = state) do
    current_position = read_position() |> Flub.pub(__MODULE__)
    check_position(interval_ms)
    {:noreply, ~M{%State state|current_position}}
  end

  #####################
  # Internal Functions
  #####################

  def check_position(interval_ms) do
    @process.send_after(self(), :check_position, interval_ms)
  end

  def read_position() do
    @position_provider.get_position()
  end

end
