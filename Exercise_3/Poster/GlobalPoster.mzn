int: n;
int: w;
int: h;

include "diffn.mzn";

array [1..n] of int: ws; 
array [1..n] of int: hs;


%left bottom coordinates
array [1..n] of var 0..w: Xs; 
array [1..n] of var 0..h: Ys;


%each poster is inside  

constraint forall(i in 1..n) (
  Xs[i] + ws[i] <= w
);

constraint forall(i in 1..n) (
  Ys[i] + hs[i] <= h
);

constraint diffn(Xs, Ys, ws, hs);


array [1..2*n] of var int: all_vars;

constraint forall(i in 1..n) (
  Xs[i] == all_vars[2 * i - 1] /\ Ys[i] == all_vars[2*i]
);

% (1) input order – min value
%solve::int_search(Xs, input_order, indomain_min)::int_search(Ys, input_order, indomain_min) satisfy;
%solve::int_search(all_vars, input_order, indomain_min) satisfy;

% (2) input order – random value
%solve::int_search(Xs, input_order, indomain_random)::int_search(Ys, input_order, indomain_random) satisfy;
%solve::int_search(all_vars, input_order, indomain_random) satisfy;

% (3) min domain size – min value
%solve::int_search(Xs, first_fail, indomain_min)::int_search(Ys, first_fail, indomain_min) satisfy;
%solve::int_search(all_vars, first_fail, indomain_min) satisfy;

% (4) min domain size – random value
%solve::int_search(Xs, first_fail, indomain_random)::int_search(Ys, first_fail, indomain_random) satisfy;
%solve::int_search(all_vars, first_fail, indomain_random) satisfy;

% (5) domWdeg – min value
%solve::int_search(Xs, dom_w_deg, indomain_min)::int_search(Ys, dom_w_deg, indomain_min) satisfy;
%solve::int_search(all_vars, dom_w_deg, indomain_min) satisfy;


% (6) domWdeg – random value
%solve::int_search(Xs, dom_w_deg, indomain_random)::int_search(Ys, dom_w_deg, indomain_random) satisfy;
solve::int_search(all_vars, dom_w_deg, indomain_random) satisfy;

