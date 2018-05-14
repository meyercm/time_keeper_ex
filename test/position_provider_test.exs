defmodule PositionProviderTest do
  use ExUnit.Case
  alias TimeKeeper.PositionProvider

  test "it can parse xdotool's output" do
    result = PositionProvider.parse_getloc("x:720 y:439 screen:0 window:417\n")
    assert(%{x: 720, y: 439} == result)
  end
end
