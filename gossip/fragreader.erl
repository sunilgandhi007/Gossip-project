-module(fragreader).
-compile(export_all).

genfrags(Nodes, Factor) ->
    {ok, Device} = file:open(randnofile, [read]),
        Parts = get_all_lines(Device, [], 1),
            fragmentize(Parts, length(Parts),[], Nodes, Factor).

get_all_lines(Device, Accum, Index) ->
	case io:fread(Device, "","~f") of
		eof -> file:close(Device), Accum;
        	{ok, [N]} ->
             	get_all_lines(Device, Accum ++ [{Index, N}], Index+1)
	end.

fragmentize(Parts, Len, Fragments, Nodes, Factor) when length(Fragments) < Nodes ->
    %Initial N Fragment Creation
	fragmentize(Parts, Len, Fragments ++ [[lists:nth(random:uniform(length(Parts)), Parts)]], Nodes, Factor);

fragmentize(Parts, Len, Fragments, Nodes, Factor) when Len > 0 ->
    %Selecting a value from Parts and calling add3
    Index = Factor,
	add3(Parts, Len, lists:nth(Len, Parts), Fragments, Index, Nodes, Factor);

fragmentize(Parts, Len, Fragments, Nodes, Factor) when Len == 0 ->
	Fragments.

add3(Parts, Len, Value, Fragments, Index, Nodes, Factor) when Index == 0 ->
    %Done adding 3 times, calling fragmentize to get the next Value to be distributed
	fragmentize(Parts, Len-1, Fragments, Nodes-1, Factor); %return to fragmentize

add3(Parts, Len, Value, Fragments, Index, Nodes, Factor) when Index > 0 ->
    %Distributes a Part among 3 random fragments
    Frag = lists:nth(random:uniform(length(Fragments)), Fragments),
    {K, V} = Value,
    Found = lists:keyfind(K, 1, Frag),
    if 
        Found == false -> Temp= lists:delete(Frag, Fragments),
        add3(Parts, Len, Value, [[Value | Frag]|Temp], Index-1, Nodes, Factor);
        true -> add3(Parts, Len, Value, Fragments, Index, Nodes, Factor)
    end.

