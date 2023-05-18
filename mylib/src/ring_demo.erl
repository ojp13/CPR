-module(ring_demo).

-compile(export_all).

start(Num, MsgNum) ->
    spawn(?MODULE, init, [Num, MsgNum]).


init(Num, MsgNum) -> 
    io:format("~p Started Main:~p~n", [Num, self()]),
    Pid = start_child(Num-1, self(), MsgNum),
    Pid ! ok,
    main(Pid, Num, MsgNum).


main(Pid, Num, 0) -> 
    receive ok -> ok end,
    io:format("~p main stopping ~n", [Num]),
    Pid ! stop;
main(Pid, Num, MsgNum) ->
    receive 
        ok -> 
            io:format("~p got ok~n", [Num]),
            Pid ! ok,
            main(Pid, Num, MsgNum-1);
        stop -> 
            io:format("~p stopping ~n", [Num]),
            Pid ! stop
    end.

start_child(0, Pid, _) ->
    Pid;
start_child(Num, Pid, MsgNum) ->
    ChildPid = spawn(?MODULE, loop,[Num, Pid]),
    start_child(Num - 1, ChildPid, MsgNum).


loop(Num, Pid) -> 
    io:format("~p ~p loop: sending to ~p ~n", [Num, self(), Pid]),
    receive 
        ok ->
            io:format("~p received ok ~n", [Num]),
            Pid ! ok,
            loop(Num, Pid);
        stop ->
            io:format("~p stopping ~n", [Num]),
            Pid ! stop,
            ok
    end.

