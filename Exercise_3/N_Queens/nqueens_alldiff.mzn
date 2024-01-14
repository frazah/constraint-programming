% Alldifferent model

include "alldifferent.mzn";

int: n; % Number of queens
array [1..n] of var 1..n: q; % Variables for queens on the rows (or columns)

% Column attack and Diagonal attack constraints using the alldifferent constraint
% Append ::domain to the end.  
constraint alldifferent(q)::domain;  %%column constraint
constraint alldifferent([q[i] + i | i in 1..n])::domain; %% explicit abs value 
constraint alldifferent([q[i] - i | i in 1..n])::domain;

% Search for all solutions, using N = 30, 35, 45, 50
%solve satisfy;

% (1) input order – min value
%solve::int_search(q, input_order, indomain_min) satisfy;

% (2) input order – random value
%solve::int_search(q, input_order, indomain_random) satisfy;

% (3) min domain size – min value
%solve::int_search(q, first_fail, indomain_min) satisfy;

% (4) min domain size – random value
%solve::int_search(q, first_fail, indomain_random) satisfy;

% (5) domWdeg – min value
%solve::int_search(q, dom_w_deg, indomain_min) satisfy;

% (6) domWdeg – random value
%solve::int_search(q, dom_w_deg, indomain_random) satisfy;