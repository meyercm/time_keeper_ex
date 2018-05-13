defmodule TimeKeeperTest do
  use ExUnit.Case
  doctest TimeKeeper

  test "greets the world" do
    assert TimeKeeper.hello() == :world
  end
end
