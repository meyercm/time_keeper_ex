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
    file = get_detail_path(minute)
    write(file, format_line(minute, value))
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

  def write(file, content) do
    File.mkdir_p(Path.dirname(file))
    File.open(file, [:append], fn(f) ->
      IO.write(f, content)
    end)
  end

  @root_path ".timekeeper"

  def get_changes_path({y, m, d, _hh, _mm}) do
    Path.join([System.user_home(), @root_path, "#{y}-#{pad(m)}", "#{y}-#{pad(m)}-#{d}.log"])
  end

  def get_detail_path({y, m, d, _hh, _mm}) do
    Path.join([System.user_home(), @root_path, "#{y}-#{pad(m)}", "#{y}-#{pad(m)}-#{d}.detail_log"])
  end

  def format_line({y, m, d, hh, mm}, content) do
    "#{y}#{@months[m]}#{pad(d)} #{pad(hh)}:#{pad(mm)} #{content}\n"
  end

  def pad(val), do: String.pad_leading("#{val}", 2, "0")
end
