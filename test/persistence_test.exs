defmodule PersistenceTest do
  use ExUnit.Case

  alias TimeKeeper.Persistence

  test "it generates the proper filename for details" do
    homedir = System.user_home
    assert(homedir <> "/.timekeeper/2018-05/2018-05-13.detail_log" == Persistence.get_detail_path({2018, 05, 13, 7, 12}))
  end

  test "it generates the proper filename for changes" do
    homedir = System.user_home
    assert(homedir <> "/.timekeeper/2018-05/2018-05-13.log" == Persistence.get_changes_path({2018, 05, 13, 7, 12}))
  end

  test "format_line produces the correct file input" do
    assert ("2018MAY13 08:15 12\n" == Persistence.format_line({2018, 5, 13, 8, 15}, 12))
  end

  test "it can parse a line from a details file" do
    assert({{2018, 5, 13, 8, 15}, 12} == Persistence.parse_line("2018MAY13 08:15 12\n"))
  end

  test "it can read back a file" do
    assert([
      {{2018, 5, 13, 8, 15}, 12},
      {{2018, 5, 13, 8, 16}, 12},
      {{2018, 5, 13, 8, 17}, 12},
      {{2018, 5, 13, 8, 18}, 12},
      {{2018, 5, 13, 8, 19}, 12},
      {{2018, 5, 13, 8, 20}, 12},
    ] == Persistence.read_file(Path.join(Path.dirname(__ENV__.file), "resources/sample_1.log")))
  end

end
