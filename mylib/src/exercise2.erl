-module(exercise2).

-export([suminteger/1, suminterval/2, create/1, reverse_create/1, print_int/1, print_evenint/1]).

suminteger(X) -> suminteger(X, 0).

suminteger(0, Buff) ->
    Buff;
suminteger(X, Buff) ->
    suminteger(X-1, X + Buff).

suminterval(X, Y) when X == Y -> X;
suminterval(X, Y) when X < Y -> 
    Y + suminterval(X, Y-1).

create(0) -> [];
create(X) when is_integer(X) ->
    create(X-1) ++ [X].

reverse_create(0) -> [];
reverse_create(X) when is_integer(X)-> 
    [X|reverse_create(X-1)].

print_int(0) -> "";
print_int(X) when is_integer(X) ->
    print_int(X-1),
    io:format("~p~n", [X]).

print_evenint(X) when X =< 1 -> ok; 
print_evenint(X) when X rem 2 == 0 -> 
    print_evenint(X-2),
    io:format("~p~n", [X]);
print_evenint(X) when X rem 2 == 1 -> 
    print_evenint(X-1).

