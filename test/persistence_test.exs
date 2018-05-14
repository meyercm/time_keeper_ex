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

  test "format_line produces tiihe correct file input" do
    assert ("2018MAY13 08:15 12\n" == Persistence.format_line({2018, 5, 13, 8, 15}, 12))
  end
end
