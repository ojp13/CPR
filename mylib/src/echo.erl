-module(echo).

-export([start/0, loop/0, stop/0, print/1]).

start() ->
    Pid = spawn(echo, loop, []),
    register(echo, Pid).

stop() ->
    echo ! stop.

print(Term) ->
    echo ! {print, Term}.

loop() ->
    receive
        {print, Term} ->
            io:format("~p~n", [Term]),
            loop();
        stop ->
            ok
    end.

