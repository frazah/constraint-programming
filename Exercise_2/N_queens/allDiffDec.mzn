int: n; % Number of queens
array [1..n] of var 1..n: cols; % Variables for queens on the rows (or columns)

% Column attack and Diagonal attack constraints using the alldifferent constraint
% Append ::domain to the end.

%constraint alldifferent(cols)::domain;
%constraint alldifferent([cols[i] + i | i in 1..n])::domain;
%constraint alldifferent([cols[i] - i | i in 1..n])::domain;
% Search for all solutions, using N = 8, 9, 10, and 12.

constraint forall(i, j in 1..n where i < j) (cols[i] != cols[j]);

constraint forall(i, j in 1..n where i < j) (cols[i] + i != cols[j] + j);
constraint forall(i, j in 1..n where i < j) (cols[i] - i != cols[j] - j);


solve::int_search(cols, input_order, indomain_min) satisfy;