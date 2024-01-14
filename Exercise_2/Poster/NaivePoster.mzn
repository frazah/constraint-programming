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


%% These constraint significantly reduce the failures
%posters don´t exceed vertical space, implied

constraint
  forall (i in 1..w) (
    sum(j in 1..n where Xs[j] <= i /\ i <= Xs[j] + ws[j]) (hs[j]) <= h
  );
  
%posters don't exceed horizontal space, implied
constraint
 forall (i in 1..h) (
    sum(j in 1..n where Ys[j] <= i /\ i <= Ys[j] + hs[j]) (ws[j]) <= w
  );
  

% posters must not overlap
constraint 
  forall(i, j in 1..n where i < j) (
    Xs[i] >= Xs[j] + ws[j]
      \/ Xs[i] + ws[i] <= Xs[j]
      \/ Ys[i] + hs[i] <= Ys[j]
      \/ Ys[i] >= Ys[j] + hs[j]
  );
  
solve satisfy;

