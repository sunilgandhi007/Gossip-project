-module(updateFound).
-compile(export_all).

upFound(Myvalue, Value, Fragment) ->
    Mytuple = hd(Myvalue),
    Tuple = hd(Value),
    if Mytuple == {0, 0} ->
        {K, V} = Tuple;
        true -> {K, V} = Mytuple 
    end,
    case lists:keyfind(K, 1, Fragment) of
        false -> [[{K,V}], Fragment];
        X -> Temp = [[{K,V}], [{K, V}|lists:delete(X, Fragment)]],
        io:format("Updated Fragment, Previous ~p -> Now ~p~n", [Fragment, Temp]),
        Temp
    end.
    
    
            
