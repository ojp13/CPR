-module(ring).

-export([start/2, loop/2]).


start(0, _) -> [];
start(N, M) ->
    start(N, M, self()).

start(0, M, Pid) ->
    Pid ! {print, test},
    loop(Pid, M);
start(N, M, Pid) ->
    NewPid = spawn(ring, loop, [Pid, M]),
    start(N-1, M, NewPid).


loop(NextPid, 0) ->
    receive
        _ ->        
            % io:format("~p Quitting and Sending Quit Message To ~p ~n", [self(), NextPid]),
            NextPid ! quit,
            ok
    end;
loop(NextPid, M) ->
    receive
        {print, Term} ->
            % io:format("~p Sending ~p To ~p with counter ~p ~n", [self(), Term, NextPid, M]),
            NextPid ! {print, Term},
            loop(NextPid, M - 1);
        stop ->
            ok
    end.
