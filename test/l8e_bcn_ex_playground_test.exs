defmodule L8eBcnExPlaygroundTest do
  use ExUnit.Case
  alias Bcn.Example
  doctest Example

  test "handle_call" do
    {:ok, pid} = Example.start_link()
    Example.call(pid, "test123!")
    {:ok, state} = Example.get_state(pid)
    assert state == ["test123!"]
  end
end
