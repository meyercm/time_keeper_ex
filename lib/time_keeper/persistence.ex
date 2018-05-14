defmodule TimeKeeper.Persistence do
  require Logger
  ######
  # API
  ######
  def write_change(minute, :started) do
    file = get_changes_path(minute)
    content = format_line(minute, "Started moving")
    write(file, content)
  end
  def write_change(minute, :stopped) do
    file = get_changes_path(minute)
    content = format_line(minute, "Stopped moving")
    write(file, content)
  end


  def write_minute(minute, value) do
    file = get_path(minute)
    File.mkdir_p(Path.dirname(file))
    File.open(file, [:append], fn(f) ->
      case make_line(minute, value) do
        nil -> :noop
        line ->
          Logger.debug("writing #{inspect line} to #{Path.basename(file)}")
          IO.write(f, line)
      end
    end)
  end

  #####################
  # Internal functions
  #####################

  @months %{
    1 => "JAN",
    2 => "FEB",
    3 => "MAR",
    4 => "APR",
    5 => "MAY",
    6 => "JUN",
    7 => "JUL",
    8 => "AUG",
    9 => "SEP",
    10 => "OCT",
    11 => "NOV",
    12 => "DEC",
  }
  @root_path ".timekeeper"

  def write(file, content) do
  end

  def format_line(minute, content) do
  end

  def get_changes_path({y, m, d, _hh, _mm}) do
    Path.join([System.user_home(), @root_path, "#{y}-#{pad(m)}", "#{y}-#{pad(m)}-#{d}.log"])
  end
  def get_path({y, m, d, _hh, _mm}) do
    Path.join([System.user_home(), @root_path, "#{y}-#{pad(m)}", "#{y}-#{pad(m)}-#{d}.log"])
  end

  def make_line(_minute, 0), do: nil
  def make_line({y, m, d, hh, mm}, value) do
    "#{y}#{@months[m]}#{pad(d)} #{pad(hh)}:#{pad(mm)} #{value}\n"
  end

  def pad(val), do: String.pad_leading("#{val}", 2, "0")
end
