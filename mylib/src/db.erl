-module(db).

-export([new/0, write/3, delete/2, destroy/1, read/2, match/2]).

new() -> 
    [].

destroy(_DbRef) -> 
    [].

write(Key, Element, []) -> 
    [{Key, Element}];
write(Key, Element, [{Key, _}|T]) -> 
    [{Key, Element} | T];
write(Key, Element, [H|T]) -> 
    [H | write(Key, Element, T)].


delete(_, []) -> [];
delete(Key, [{Key, _}|T]) ->
    T;
delete(Key, [H|T]) ->
    [H | delete(Key, T)].

read(_, []) -> {error, instance};
read(Key, [{Key, Value}|_]) ->
    {ok, Value};
read(Key, [_|T]) ->
    read(Key, T).

match(_, []) -> [];
match(V, [{K, V} | T]) ->
    [K | match(V, T)];
match(V, [_|T]) ->
    match(V, T).

        
