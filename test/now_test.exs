Code.require_file "test_helper.exs", __DIR__

defmodule Now.Test do
  use ExUnit.Case
  require Now

  doctest Now

  test "system_time" do
    system_time = case Now.system_time do
      system_time when system_time |> is_integer -> system_time
      _ -> -1
    end
    assert system_time > 0
  end

end
