include "alldifferent.mzn";

int: N;  %size of square
array [1..N, 1..N] of 0..N: start;

array [1..N, 1..N] of var 1..N: square;


constraint forall (i in 1..N, j in 1..N) (
  if start[i, j] != 0 then square[i,j] == start[i,j] endif
);

constraint forall (i in 1..N) (
  alldifferent(row(square, i))::domain
  /\ alldifferent(col(square, i))::domain
);

%solve satisfy;
%solve::int_search(square, dom_w_deg, indomain_random) satisfy;
solve::int_search(square, dom_w_deg, indomain_random)::restart_luby(N) satisfy;

