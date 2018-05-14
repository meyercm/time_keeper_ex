defmodule TimeKeeper.ActivityTracker do
  use GenServer
  import ShorterMaps
  require Logger
  alias TimeKeeper.{MouseWatcher, Persistence}

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  defmodule State do
    @moduledoc false
    defstruct [
      current_minute: nil,
      last_position: nil,
      distance: 0,
    ]
  end

  ######################
  # GenServer callbacks
  ######################

  def init([]) do
    Flub.sub(MouseWatcher)
    {:ok, %State{current_minute: get_current_minute()}}
  end

  def handle_info(%Flub.Message{channel: MouseWatcher, data: position}, ~M{current_minute} = state) do
    state = update_position_and_distance(state, position)
    state = case get_current_minute() do
      ^current_minute -> state
      new_minute ->
        Logger.debug("new minute (#{inspect new_minute}) started")
        Persistence.write_minute(state.current_minute, state.distance)
        %{state|current_minute: new_minute, distance: 0}
    end
    {:noreply, state}
  end

  #####################
  # Internal Functions
  #####################

  def update_position_and_distance(~M{last_position} = state, last_position) do
    state
  end
  def update_position_and_distance(~M{last_position, distance} = state, new_position) do
    distance = distance + calc_distance(last_position, new_position)
    ~M{%State state|distance, last_position: new_position}
  end

  def get_current_minute() do
    {{y, m, d}, {hh, mm, _ss}} = :calendar.local_time()
    {y, m, d, hh, mm}
  end

  def calc_distance(~M{x, y}, ~M{x, y}), do: 0
  def calc_distance(~M{x, y}, %{x: x1, y: y1}) do
    :math.sqrt(:math.pow(x1 - x, 2) + :math.pow(y1 - y, 2))
    |> round()
  end
  def calc_distance(_, _), do: 0

end
