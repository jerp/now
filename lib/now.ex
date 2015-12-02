defmodule Now do

  @moduledoc """
  defines macros `Now.timestamp` and `Now.system_time`.
  When erlang < v18, it replies on `:erlang.now()`
  otherwise uses native function.

      iex> defmodule MyModule do
      ...>   require Now
      ...>   use Bitwise, only_operators: true
      ...>   # generates a prefix based on system time
      ...>   def gen_prefix do
      ...>     Now.system_time() &&& 281474976710655
      ...>   end
      ...> end
      ...> MyModule.gen_prefix > 0
      true
 """

  erlang_now_is_deprecated? = Enum.member?(Mix.Project.get!.project[:erlc_options] || [], {:d, :time_correction})
  if erlang_now_is_deprecated? do
    @doc "Returns time stamp {mega_seconds, seconds, micro_seconds}"
    defmacro timestamp, do: quote(do: :erlang.timestamp)
    @doc "Returns system_time in micro_seconds"
    defmacro system_time, do: quote(do: :erlang.system_time(:micro_seconds))
  else
    @doc "Returns time stamp {mega_seconds, seconds, micro_seconds}"
    defmacro timestamp, do: quote(do: :erlang.now)
    @doc "Returns system_time in micro_seconds"
    defmacro system_time do
      quote do
        {gs, s, ms} = :erlang.now
        gs * 1000000000000 + s * 1000000 + ms
      end
    end
  end
end
