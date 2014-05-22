-module(floppystore).

-export([confirm/0]).

-include_lib("eunit/include/eunit.hrl").

-define(HARNESS, (rt_config:get(rt_harness))).

confirm() ->
    simple_test().

simple_test() ->
    [Nodes] = rt:build_clusters([1]),

    FirstNode = hd(Nodes),
    lager:info("Nodes: ~p", [Nodes]),

    WriteResult = rpc:call(FirstNode, floppy, append, [abc, {increment, 4}]),
    ?assertMatch({ok, _}, WriteResult),

    ReadResult = rpc:call(FirstNode, floppy, read, [abc, riak_dt_gcounter]),
    ?assertEqual(1, ReadResult),

    ok.
