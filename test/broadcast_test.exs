defmodule BroadcastTest do
  use ExUnit.Case
  doctest Broadcast

  test "greets the world" do
    assert Broadcast.hello() == :world
  end
end
