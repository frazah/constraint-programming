% Alldifferent model

include "alldifferent.mzn";

int: n; % Number of queens
array [1..n] of var 1..n: q; % Variables for queens on the rows (or columns)

% Column attack and Diagonal attack constraints using the alldifferent constraint
% Append ::domain to the end.  

constraint alldifferent(q)::domain;  %%column constraint

constraint alldifferent([q[i] + i | i in 1..n])::domain; %% explicit abs value 
constraint alldifferent([q[i] - i | i in 1..n])::domain;

var int: diagonal_distance = sum(i in q) (abs(q[i] - i));

%% DEFAULT SEARCH
%solve minimize diagonal_distance;

%% domWdeg – random value
%solve::int_search(q, dom_w_deg, indomain_random) minimize diagonal_distance;

%% + LUBY RESTART
%solve::int_search(q, dom_w_deg, indomain_random)::restart_luby(250) minimize diagonal_distance;

%% + LNS
solve::int_search(q, dom_w_deg, indomain_random)::restart_luby(250)::relax_and_reconstruct(q, 85) minimize diagonal_distance;

output ["obj: \(diagonal_distance)"];