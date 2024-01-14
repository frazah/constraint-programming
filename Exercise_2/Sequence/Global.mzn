int: n;
array[0..n-1] of var 0..n-1: x;

include "global_cardinality.mzn";
 
 
% global
%constraint global_cardinality(x, [i | i in 0..n-1], [x[i] | i in 0..n-1]);
constraint global_cardinality(x, array1d(0..n-1) , array1d(x));


% the first implied constraint
%constraint sum(i in 0..n-1)(x[i]) = n;

% the second implied constraint
%constraint sum(i in 0..n-1)(x[i] * i) = n;

solve satisfy;

output [ "x = \(x);\n" ] ;