-module(my_db).

-compile(export_all).


start() ->
    DbServer = spawn(my_db, init, []),
    register(dbserver, DbServer).

init() ->
    State = db:new(),
    db_server(State).

write(Key, Element) ->
    io:format("Writing {~p, ~p} to Db Server with Pid ~p ~n", [Key, Element, dbserver]),
    dbserver ! {write, Key, Element}.

delete(Key) ->
    io:format("Deleting element with key ~p from Db Server with Pid ~p ~n", [Key, dbserver]),
    dbserver ! {delete, Key}.

read(Key) ->
    dbserver ! {read, Key, self()},
    receive 
        {read_response, Data} ->
            io:format("Received read data from database~n"),
            Data
    end.

match(Value) ->
    dbserver ! {match, Value, self()},
    receive
        {match_response, Data} ->
            io:format("Received match data from database~n"),
            Data
    end.

shutdown() ->
    dbserver ! stop.


db_server(Db) ->
    io:format("Db Server with Pid ~p and data ~p exists ~n", [self(), Db]),
    receive 
        {write, Key, Element} ->
            NewDb = db:write(Key, Element, Db),
            io:format("Database with Pid ~p updated by write~n", [self()]),
            db_server(NewDb);
        {delete, Key} ->
            NewDb = db:delete(Key, Db),
            io:format("Database with Pid ~p updated by delete~n", [self()]),
            db_server(NewDb);
        {read, Key, RequestingPid} ->
            Data = db:read(Key, Db),
            io:format("Sucessfully read data from database with Pid ~p~n", [self()]),
            RequestingPid ! {read_response, Data},
            db_server(Db);
        {match, Value, RequestingPid} ->
            Data = db:match(Value, Db),
            io:format("Sucessfully matched data from database with Pid ~p~n", [self()]),
            RequestingPid ! {match_response, Data},
            db_server(Db);
        stop ->
            io:format("Db Server with Pid ~p stopping~n", [self()]),
            ok
    end.


