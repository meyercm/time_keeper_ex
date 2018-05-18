defmodule TimeKeeper.Persistence do
  require Logger

  import TimeKeeper.Utils
  import ShorterMaps
  import PredicateSigil

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

  def read_file({y,m,d}) do
    get_detail_path({y, m, d, 0, 0})
    |> read_file()
  end
  def read_file(path) when is_binary(path) do
    read_detail(path)
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

  @inv_months Map.new(@months, fn {k, v} -> {v, k} end)

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

  @re_mon Map.values(@months) |> Enum.join("|")
  @re_parse_detail ~r/(?<y>\d{4})(?<mon>#{@re_mon})(?<d>\d{2}) (?<hh>\d{2}):(?<mm>\d{2}) (?<content>\d+)/
  def parse_line(str) do
    case Regex.named_captures(@re_parse_detail, str) do
      nil -> nil
      ~m{y, mon, d, hh, mm, content} -> {
        {
          y |> String.to_integer(),
          @inv_months[mon],
          d |> String.to_integer(),
          hh |> String.to_integer(),
          mm |> String.to_integer()},
        content |> String.to_integer()
      }
    end
  end

  def read_detail(file) do
    if File.exists?(file) do
      File.read!(file)
      |> String.split("\n")
      |> Enum.map(&parse_line/1)
      |> Enum.reject(~p(nil))
    else
      []
    end
  end

end
