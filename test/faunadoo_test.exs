defmodule FaunadooTest do
  use ExUnit.Case
  doctest Faunadoo

  test "greets the world" do
    assert Faunadoo.hello() == :world
  end
end
