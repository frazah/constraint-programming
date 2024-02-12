% Combined alldifferent & symmetry breaking model
include "alldifferent.mzn";
include "inverse.mzn";

int: n; % Number of queens
array [1..n] of var 1..n: X;

%%% Alldiff model
constraint alldifferent(X)::domain;
constraint alldifferent([X[i] + i | i in 1..n])::domain;
constraint alldifferent([X[i] - i | i in 1..n])::domain;


%%% Integration of the Boolean model 

array [1..n,1..n] of var bool: B;

/*
channeling constraint, this links the two boards
we need the boolean matriX to check for symmetry 
*/
constraint forall(i in 1..n, j in 1..n) (
    (X[i] = j) <-> (B[i,j] = 1)
);

%%% Symmetry breaking

constraint
    lex_lesseq(array1d(B), [ B[j,i] | i,j in 1..n ])
/\  lex_lesseq(array1d(B), [ B[i,j] | i in reverse(1..n), j in 1..n ])
/\  lex_lesseq(array1d(B), [ B[j,i] | i in 1..n, j in reverse(1..n) ])
/\  lex_lesseq(array1d(B), [ B[i,j] | i in 1..n, j in reverse(1..n) ])
/\  lex_lesseq(array1d(B), [ B[j,i] | i in reverse(1..n), j in 1..n ])
/\  lex_lesseq(array1d(B), [ B[i,j] | i,j in reverse(1..n) ])
/\  lex_lesseq(array1d(B), [ B[j,i] | i,j in reverse(1..n) ]);

%%% Search for all solutions, using N = 8, 9, 10, and 12.

solve satisfy;

