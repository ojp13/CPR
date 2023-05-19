-module(db).

-export([new/0, write/3, delete/2, destroy/1, read/2, match/2]).

-include("data.hrl").

new() -> 
    TabId = ets:new(?MODULE, [set, named_table, {keypos, #data.key}]),
    TabId.

destroy(_DbRef) -> 
    ets:delete(?MODULE).

write(Key, Element, TabId) -> 
    ets:insert(TabId, #data{key=Key, value=Element}),
    TabId.

delete(Key, TabId) ->
    ets:delete(TabId, Key),
    TabId.

read(Key, TabId) ->
    case ets:lookup(TabId, Key) of 
        [] -> {error, instance};
        [#data{value=Element}] -> Element
    end.

match(Value, TabId) ->
    lists:flatten(ets:match(TabId, #data{key='$0', value=Value})).

        
