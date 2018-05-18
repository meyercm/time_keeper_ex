defmodule TimeKeeper.Reports do
  import ShorterMaps
  import PredicateSigil

  import TimeKeeper.Utils
  alias TimeKeeper.Persistence

  defmodule Options do
    defstruct [
      idle_gap_min: 10,
      include_idle: true,
    ]
  end

  def print(date_query, options \\ %Options{}) do
    build_reports(date_query, options)
    |> Enum.join("\n")
  end

  def build_reports(item_or_items, options \\ %Options{})
  def build_reports(list, options) when is_list(list) do
    Enum.map(list, &(do_build_report(&1, options)))
    |> Enum.join("\n\n")
  end
  def build_reports(item, options), do: build_reports([item], options)

  def do_build_report(offset, options) when is_integer(offset) do
    {d, _t} = :calendar.local_time()
    (:calendar.date_to_gregorian_days(d) - offset)
    |> :calendar.gregorian_days_to_date()
    |> do_build_report(options)
  end
  def do_build_report({_y, _m, _d} = date, options) do
    Persistence.read_file(date)
    |> format_data(options)
  end

  def format_data(data, ~M{%Options idle_gap_min, include_idle} \\ %Options{}) do
    data
    |> Enum.sort
    |> break_at(idle_gap_min) # List of lists now
    |> Enum.map(&format_group/1)
    |> Enum.reject(~p(nil))
    |> inject_idle(include_idle)
    |> Enum.map(&(&1.output))
    |> Enum.join("\n")
  end

  def inject_idle(list, false), do: list
  def inject_idle(list, true) do
    do_inject_idle(list, [])
  end

  def do_inject_idle([a, b|rest], acc) do
    delta = calc_delta(b.first, a.last)
    idle = %{output: "| #{format_delta(delta)}"}
    do_inject_idle([b|rest], [idle, a|acc])
  end
  def do_inject_idle(rest, acc), do: Enum.reverse(rest ++ acc)


  def break_at(list, gap) do
    Enum.chunk_while(list, [], &chunk_fun/2, &after_fun/1)
    |> Enum.map(&Enum.reverse/1)
  end

  def chunk_fun({_, 0}, acc), do: {:cont, acc} # discard 0s
  def chunk_fun(item, []), do: {:cont, [item]}
  def chunk_fun(item, [h|_r] = acc) do
    case calc_delta(item, h) do
      x when x > 10 -> {:cont, acc, [item]}
      _ -> {:cont, [item|acc]}
    end
  end
  def after_fun(item), do: {:cont, item, []}

  def format_group([]), do: nil
  def format_group(list_of_times) do
    [first|_rest] = list_of_times
    [last|_rest] = Enum.reverse(list_of_times)
    duration = calc_delta(last, first)
    output = "#{format_time(first)} - #{format_time(last)}   #{format_delta(duration)}"
    ~M{output, first, last}
  end

  def format_time({{_y, _m, _d, hh, mm}, _activity}) do
    "#{pad(hh)}:#{pad(mm)}"
  end

  def format_delta(duration) do
    "#{Float.round(duration / 60, 1)} hours"
  end

  def calc_delta({{y, m, d, hh1, mm1}, _}, {{y, m, d, hh2, mm2}, _}) do
    (hh1 * 60 + mm1) - (hh2 * 60 + mm2)
  end
end
