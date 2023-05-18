-module(mutex_v2).

-compile(export_all).


start() -> 
    MutexServer = spawn(?MODULE, init, []),
    register(mutexserver, MutexServer).

init() ->
    process_flag(trap_exit,true),
    free().

wait() ->
    mutexserver ! {wait, self()},
    receive
        ok ->
            io:format("Process ~p connected to server~n", [self()])
    end.
wait(kill) ->
    mutexserver ! {wait, self()},
    io:format("Killing process ~p~n", [self()]),
    exit('KILL').


signal() ->
    mutexserver ! {signal, self()},
    receive
        ok -> 
            io:format("Process ~p disconnected from server~n", [self()])
    end.

start_queue(0) -> ok;
start_queue(N) when N rem 2 == 0 ->
    spawn(?MODULE, queue, [kill]),
    start_queue(N-1);
start_queue(N) ->
    spawn(?MODULE, queue, []),
    start_queue(N-1).

queue() ->
    io:format("Process ~p queuing to server to connect~n", [self()]),
    wait(),
    signal().
queue(kill) ->
    io:format("Process ~p queuing to server to connect~n", [self()]),
    wait(kill).

free() ->
    receive
        {wait, RequestingPid} ->
            catch link(RequestingPid),
            RequestingPid ! ok,
            busy(RequestingPid)
    end.

busy(RequestingPid) ->
    receive
        {signal, RequestingPid} ->
            unlink(RequestingPid),
            RequestingPid ! ok,
            free();
        {'EXIT', RequestingPid, _} ->
            free()
    end.

