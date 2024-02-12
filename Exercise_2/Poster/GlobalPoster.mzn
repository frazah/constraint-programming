include "diffn.mzn";

int: n;
int: w;
int: h;

array [1..n] of int: ws; 
array [1..n] of int: hs;

%widths must be non-negative
constraint assert(
  forall (i in 1..n) (ws[i] >= 0) ,
  "Invalid datafile: Widths should be non-negative"
);
                  
%heights must be non-negative
constraint assert(
  forall (i in 1..n) (hs[i] >= 0) ,
  "Invalid datafile: Heights should be non-negative"
);

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
  
solve satisfy;

