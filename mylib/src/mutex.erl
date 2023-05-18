-module(mutex).

-compile(export_all).


start() -> 
    MutexServer = spawn(?MODULE, init, []),
    register(mutexserver, MutexServer).

init() ->
    free().

wait() ->
    mutexserver ! {wait, self()},
    receive
        ok ->
            io:format("Process ~p connected to server~n", [self()])
    end.

signal() ->
    mutexserver ! {signal, self()},
    receive
        ok -> 
            io:format("Process ~p disconnected from server~n", [self()])
    end.

start_queue(0) -> ok;
start_queue(N) ->
    spawn(?MODULE, queue, []),
    start_queue(N-1).

queue() ->
    io:format("Process ~p queuing to server to connect~n", [self()]),
    wait(),
    signal().

free() ->
    receive
        {wait, RequestingPid} ->
            RequestingPid ! ok,
            busy(RequestingPid)
    end.

busy(RequestingPid) ->
    receive
        {signal, RequestingPid} ->
            RequestingPid ! ok,
            free()
    end.

