defmodule TimeKeeper.PositionProvider do
  import ShorterMaps
  require Logger

  def get_position() do
    # System.cmd result looks like: {"x:720 y:439 screen:0 window:417\n", 0}
    {raw_string, 0} = System.cmd("xdotool", ["getmouselocation"])
    result = parse_getloc(raw_string)
    Logger.debug("got mouse position at #{inspect result}")
    result
  end

  def set_position(x, y) do
    Logger.debug("setting mouse position to (#{x}, #{y})")
    System.cmd("xdotool", ["mousemove", "--sync", "#{x}", "#{y}"])
  end

  # regex to extract the mouse coords.
  @getloc_re ~r/x:(?<x>\d+) y:(?<y>\d+)/

  # Set in it's own public function for testing sake.
  @doc false
  def parse_getloc(string) do
    ~m{x, y} = Regex.named_captures(@getloc_re, string)
    %{
      x: String.to_integer(x),
      y: String.to_integer(y)
    }
  end
end
