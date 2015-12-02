Transition to erlang v18 for erlang:now()
=========================================

Example of a module using the macro provided

    defmodule MyModule do
       require Now
       use Bitwise, only_operators: true
       # generates a prefix based on system time
       def gen_prefix do
         Now.system_time() &&& 281474976710655
       end
    end


  * `Now.timestamp` -> `:erlang.timestamp` in v18 and `:erlang.now` before

  * `Now.system_time` -> `:erlang.system_time` in v18 and a conversion of the triple tuple of `:erlang.now` converted in ms.

Warning: although `:erlang.timestamp` has the same format as ':erlang.now'

Rationale
---------

This project is an atempt to answer question posted
[here on stackoverflow](http://stackoverflow.com/q/34023193/1268409)

This issue
----------
`:erlang.now()` is deprecated in v18, how to make a smooth transition.

Sample code before v18:
------------

    defmodule MyModule_v17 do
      use Bitwise, only_operators: true
      def gen_trans_prefix do
        {gs, s, ms} = :erlang.now
        (gs * 1000000000000 + s * 1000000 + ms) &&& 281474976710655
      end
    end
    best I came up with:

First fix attempt:
------------

    defmodule MyModule_v18 do
      use Bitwise, only_operators: true
      Kernel.if Keyword.get(:erlang.module_info, :exports) |> Enum.any?(fn({:system_time, 1}) -> true; (_) -> false end) do
        def gen_trans_prefix do
          :erlang.system_time(:micro_seconds) &&& 281474976710655
        end
      else
        def gen_trans_prefix do
          {gs, s, ms} = :erlang.now
          (gs * 1000000000000 + s * 1000000 + ms) &&& 281474976710655
        end
      end
    end

Better fix:
-----------

define `erlc_options` in mix and use it in `MyModule`

this is based on input from @potatosalad and [jose project](https://github.com/potatosalad/erlang-jose)

Find out more
-------------
This is already covered in the ["Time and Time Correction in Erlang" documentation](http://www.erlang.org/doc/apps/erts/time_correction.html) and also in the ["Time Goes On" postscript](http://learnyousomeerlang.com/time) to the wonderful ["Learn You Some Erlang" book](http://learnyousomeerlang.com/content).
as suggested by [Steve Vinoski](http://stackoverflow.com/a/34028175/1268409)
