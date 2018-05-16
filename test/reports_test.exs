defmodule ReportsTest do
  use ExUnit.Case

  alias TimeKeeper.Reports

  @example_1 [
    {{2018, 5, 13, 12, 0}, 123},
    {{2018, 5, 13, 12, 1}, 1234},
    {{2018, 5, 13, 12, 2}, 1},
    {{2018, 5, 13, 12, 3}, 1},
    {{2018, 5, 13, 12, 4}, 1},
    {{2018, 5, 13, 12, 5}, 1},
    {{2018, 5, 13, 12, 6}, 1},
  ]

  @example_2 [
    {{2018, 5, 13, 13, 0}, 123},
    {{2018, 5, 13, 13, 1}, 1234},
    {{2018, 5, 13, 13, 2}, 1},
    {{2018, 5, 13, 13, 3}, 1},
    {{2018, 5, 13, 13, 4}, 1},
    {{2018, 5, 13, 13, 5}, 1},
    {{2018, 5, 13, 13, 6}, 1},
  ]

  test "it shows a single line" do
    assert("12:00 - 12:06   0.1 hours" == Reports.format_data(@example_1, %Reports.Options{include_idle: false}))
  end

  test "it shows two lines, plus a gap" do
    expected = ~S(12:00 - 12:06   0.1 hours
| 0.9 hours
13:00 - 13:06   0.1 hours)

    assert(expected == Reports.format_data(@example_1 ++ @example_2))
  end

end
