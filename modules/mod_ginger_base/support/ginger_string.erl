-module(ginger_string).

-export([encode/1]).

-include("zotonic.hrl").

-spec encode(term()) -> binary().
encode(<<Value/binary>>) ->
    encode(binary:bin_to_list(Value));
encode(Value) ->
    case z_string:is_string(Value) of
        true ->
            z_convert:to_binary(Value);
        false ->
            ginger_type:error("string", Value)
    end.
