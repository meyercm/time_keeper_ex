defmodule PersistenceTest do
  use ExUnit.Case

  alias TimeKeeper.Persistence

  test "it generates the proper filename" do
    homedir = System.user_home
    assert(homedir <> "/.timekeeper/2018-05/2018-05-13.log" == Persistence.get_path({2018, 05, 13, 7, 12}))
  end

  test "make_line gives nil for 0 distance" do
    assert (nil == Persistence.make_line({1,2,3,4,5}, 0))
  end
  test "make_line produces the correct file input" do
    assert ("2018MAY13 08:15 12\n" == Persistence.make_line({2018, 5, 13, 8, 15}, 12))
  end
end
