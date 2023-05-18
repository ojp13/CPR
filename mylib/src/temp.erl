-module(temp).
-export([f2c/1, c2f/1, convertTemp/1]).

f2c(Fahrenheit) -> 
    (5 * (Fahrenheit - 32)) / 9.

c2f(Celsius) -> 
    ((9 * Celsius) / 5) + 32.

convertTemp({f, Fahrenheit}) -> 
    f2c(Fahrenheit);
convertTemp({c, Celsius}) ->
    c2f(Celsius).
