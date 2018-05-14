defmodule MouseWatcherTest do
  use ExUnit.Case
  alias TimeKeeper.MouseWatcher
  # import Mockery.Assertions
  # use Mockery

  # test "it schedules a query immediately after startup" do
  #   mock Process, :send_after
  #   {:ok, pid} = MouseWatcher.start_link()
  #
  #   #assert_called(Process, :send_after, [pid, :check_position, 0])
  #   assert_called(Process, :send_after)
  #   Process.exit(pid, :die)
  # end

  # test "read_position gets the position" do
  #   mock TimeKeeper.PositionProvider, :get_position
  #   #{:ok, pid} = MouseWatcher.start_link()
  #   MouseWatcher.read_position(%{interval_ms: 1})
  #   assert_called(TimeKeeper.PositionProvider, :get_position)
  #   #Process.exit(pid, :die)
  # end
end
