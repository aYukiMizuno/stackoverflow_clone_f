defmodule StackoverflowCloneF.MapUtilTest do
  use StackoverflowCloneF.CommonCase
  alias StackoverflowCloneF.MapUtil

  test "underscore_keys/1" do
    assert MapUtil.underscore_keys(%{"fooBar1" => 1, "foo_bar2" => 1}) == %{"foo_bar1" => 1, "foo_bar2" => 1}
    assert MapUtil.underscore_keys(%{"fooBar1" => %{"fooBar2" => 1}})  == %{"foo_bar1" => %{"foo_bar2" => 1}}
  end
end
