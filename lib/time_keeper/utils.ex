defmodule TimeKeeper.Utils do
  def pad(val), do: String.pad_leading("#{val}", 2, "0")
end
