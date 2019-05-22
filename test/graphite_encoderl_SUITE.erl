%% Auto-generated by https://github.com/Pouriya-Jahanbakhsh/estuff
%% -----------------------------------------------------------------------------
-module(graphite_encoderl_SUITE).
-author('pouriya.jahanbakhsh@gmail.com').
%% -----------------------------------------------------------------------------
%% Exports:

%% ct callbacks:
-export([init_per_suite/1
        ,end_per_suite/1
        ,all/0
        ,init_per_testcase/2
        ,end_per_testcase/2]).

%% Testcases:
-export(['1'/1]).

%% -----------------------------------------------------------------------------
%% Records & Macros & Includes:

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

%% -----------------------------------------------------------------------------
%% ct callbacks:


all() ->
    ToInteger =
        fun
            ({Func, 1}) ->
                try
                    erlang:list_to_integer(erlang:atom_to_list(Func))
                catch
                    _:_ ->
                        0
                end;
            (_) -> % Arity > 1 | Arity == 0
                0
        end,
    % contains 0 for other functions:
    Ints = [ToInteger(X) || X <- ?MODULE:module_info(exports)],
    % 1, 2, ...
    PosInts = lists:sort([Int || Int <- Ints, Int > 0]),
    % '1', '2', ...
    [erlang:list_to_atom(erlang:integer_to_list(X)) || X <- PosInts].


init_per_suite(Cfg) ->
    application:start(sasl),
    Cfg.


end_per_suite(Cfg) ->
    application:stop(sasl),
    Cfg.


init_per_testcase(_TestCase, Cfg) ->
    Cfg.


end_per_testcase(_TestCase, _Cfg) ->
    ok.

%% -----------------------------------------------------------------------------
%% Test cases:


'1'(Cfg) ->
    _ = Cfg,
    ?assertMatch(["foo"," ","10"," ", _,"\n"], graphite_encoderl:encode({foo, 10})),
    ?assertMatch(["foo"," ","10"," ", _,"\n"], graphite_encoderl:encode({foo, 10}, #{return_type => iolist})),

    TS = {1,1,1},
    Data = [
        {foo, 10, 1000001},
        {"bar", 3.14, 1000001},
        {<<"baz">>, 1, TS}
    ],
    ?assertEqual(
        "foo 10 1000001\n"
        "bar 3.14 1000001\n"
        "baz 1 1000001\n",
        graphite_encoderl:encode(Data, #{return_type => string})),
    ?assertEqual(<<
        "foo 10 1000001\n"
        "bar 3.14 1000001\n"
        "baz 1 1000001\n">>,
        graphite_encoderl:encode(Data, #{return_type => binary})),

    Data2 = #{key => 3.14000000},
    ?assertMatch("key 3.14 " ++ _, graphite_encoderl:encode(Data2, #{return_type => unsafe_string})),
    ?assertEqual("foo.bar.baz 10 0\n", graphite_encoderl:encode({[foo, "bar", <<"baz">>], 10, 0}, #{return_type => string})),
    ok.
