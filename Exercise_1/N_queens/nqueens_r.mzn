% Row model

include "alldifferent.mzn";

int: n; % Number of queens
array [1..n] of var 1..n: rows; % Variables for queens on the rows

% Column attack constraints using the alldifferent constraint.
% Append ::domain to the end.  

constraint alldifferent(rows)::domain; % no column attack

% Diagonal attack constraints
/*
  You can check to see if two queens are on the same diagonal by checking the differences
  between the rows and columns of the two Qs. If the differences are the same,
  they're on the same diagonal. (Basically, if the slope of the line
  between the two queens is +-1, they're on the same diagonal.)
*/
constraint forall(i,j in 1..n where i<j) (abs(rows[i] - rows[j]) != abs(i-j)); %no diagonal attack


% Search for all solutions, using N = 8, 9, 10, and 12.
solve satisfy;
