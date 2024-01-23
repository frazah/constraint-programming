                      %%%%%%%%%%%%%%%%%%%%%%%%
                      %                      %
                      % MiniZinc cheat sheet %
                      %                      %
                      %%%%%%%%%%%%%%%%%%%%%%%%

/******************
* Model structure *
******************/

include "globals.mzn";        % use globals library

int: n;                       % fixed integer parameter
var 1..n: x;                  % integer decision variable
array[1..n] of var 1..n: y;   % array of integer decision variables
constraint sum(y) <= x;       % constraint

solve satisfy;                % find satisfying solution

output ["Solution:\n", "x = ", show(x),  % output list of strings
        "y = \(y)"];                     % interpolation \(expression)

/***********************
* Basic types          *
***********************/

int: i;
3..5: j;                     % integer

float: f;
3.0..5.0: g;                 % floating point number

bool: b;                     % boolean

set of int: s;               % set
set of 3..5: t;

enum E = { Boat, Airplane }; % enumerated type

/***********************
* Type-insts           *
***********************/

var int: x;           % declare variable 
                      % (also with float, bool, and set of int)
var 3..7: y;          % declare variable with domain (also 3.0..7.0)
var set of 10..20: s; % declare set variable (only fixed set of int!)

array[1..4,1..10] of var 0.0..100.0: f;
                      % declare 2d array of float variables

var opt 1..10: ox;    % declare optional int variable (can be 1..10 or
                      % "absent", written <>)

/*********************
* Basic Constraints  *
*********************/
constraint x = y;
constraint x < y;
constraint x <= y;
constraint x > y;
constraint x >= y;
constraint x != y;    % not equals
   
/**********************
* Logical Connectives *
**********************/
                                   % conditionals
int: d = if i > 10 then a elseif i > 0 then b else c endif;
constraint if x < y then y < z else y > z endif;
   
constraint x < y \/ y != z;        % logical "or"
constraint x < y /\ y != z;        % logical "and"
constraint x < y -> y != z;        % logical implication
constraint not (x < y /\ y > z);   % logical negation

/******************
* Set Constraints *
******************/
   
constraint s subset t;             % non-strict subset relation
constraint s intersect t subset w; % intersection
constraint s union t subset w;     % union

/***************************
* Predicates and Functions *
***************************/
   
constraint all_different(x);       % predicate call
constraint mydiv(x,y) = 2;         % function call

/********************************
* Comprehensions and generators *
********************************/

array[int] of int: a = [ i | i in 1..10];
                      % create array [1,2,3,4,5,6,7,8,9,10]

array[int] of int: a = [ i | i in 1..10 where i mod 3=0];
                      % create array [3, 6, 9]

constraint forall (i,j in 1..n where i<j) (x[i] != x[j]);
                      % is the same as
constraint forall ([ x[i] != x[j] | i,j in 1..n where i<j ]);

/****************************
* Array index set coercions *
****************************/

array[20..30] of int: i = array1d(20..30, x);

array[int,int] of float: x =
  array2d(1..10, 1..10, [ 0.0 | i,j in 1..10 ]);

/********************************
* Search and search annotations *
********************************/

solve maximize sum(x);        % optimization
solve minimize sum(x);

solve ::int_search([x,y,z], input_order, indomain_min) satisfy;
                      % search annotation
                      % variable selection (examples):
                      %   input_order, first_fail, max_regret, smallest
                      % value selection (examples):
                      %   indomain_min, indomain_max, indomain,
                      %   indomain_split, indomain_reverse_split
                      % similar for bool_search, set_search, float_search

solve ::seq_search([int_search(x, first_fail, indomain),
                    int_search(y, input_order, indomain_min)])
      satisfy;
                      % first search x, then y



/*********************
* Strings and output *
**********************/

                      % concatenation using ++
                      % join arrays using string ", "
                      % convert expression into string using show
string: s = "a" ++ join(", ",[show(x[i]) | i in 1..3]);

/****************************************
* User-defined predicates and functions *
****************************************/

predicate no_overlap(var int: start0, var int: duration0,
                     var int: start1, var int: duration1) =
  start0 + duration0 <= start1 \/ start1 + duration1 <= start0;

function var float: average(array[int] of var int: x) =
  sum(x) / length(x);



% Use this editor as a MiniZinc scratch book
% ----- INTRODUZIONE -----

% Per dichiarare una variabile, specifica prima il tipo, poi il suo intervallo, e infine il nome.
int: n = 10;                    % Una variabile intera con valore 10
var 1..10: x;                   % Una variabile decisionale che può prendere valori tra 1 e 10
var set of 1..10: y;            % Una variabile decisionale che può prendere un insieme di valori tra 1 e 10

% ----- ARRAY E MATRICI -----

% Le dichiarazioni di array e matrici seguono schemi simili:
array[1..3] of int: a = [1, 2, 3];                     % Un array di interi
array[1..2, 1..3] of int: b = [| 1, 2, 3 | 4, 5, 6 |]; % Una matrice 2x3 di interi
var array[1..3] of 1..5: c;                            % Un array di variabili decisionali

% ----- CICLI FOR -----

% In MiniZinc, i cicli 'for' sono spesso utilizzati in espressioni come somme, prodotti o vincoli.
int: sumA = sum(i in 1..3)(a[i]); % Somma gli elementi dell'array 'a'

% ----- VINCOLI PRINCIPALI -----

% Il concetto principale di MiniZinc è la definizione di vincoli. 
% I vincoli sono espressioni che devono essere soddisfatte.
constraint x + sumA <= 15;   % La somma di x e sumA deve essere minore o uguale a 15
constraint forall(i in 1..3)(a[i] != 3); % Nessun elemento in 'a' può essere uguale a 3

% ----- ESEMPIO SUDOKU -----

% Immagina di voler risolvere un piccolo problema di Sudoku.

int: n = 3;
int: N = n * n;
array[1..N, 1..N] of var 1..N: board; % La griglia di Sudoku

% I vincoli del Sudoku
constraint 
  forall(i in 1..N, j in 1..N) (
    % Vincoli sulle righe
    all_different([board[i, k] | k in 1..N]) 
    /\
    % Vincoli sulle colonne
    all_different([board[k, j] | k in 1..N]) 
    /\
    % Vincoli sui blocchi
    all_different([board[n*(i-1) + k, n*(j-1) + l] | k in 1..n, l in 1..n])
  );

% Qui puoi aggiungere i vincoli per i numeri già noti sul tabellone
% E.g., se la cella (1,1) ha il numero 5:
% constraint board[1,1] = 5;

solve satisfy; % Cerca una soluzione che soddisfa i vincoli

% NOTA: Il simbolo /\ in MiniZinc rappresenta l'operatore "AND" logico.
% È usato per combinare più vincoli in modo che tutti debbano essere soddisfatti simultaneamente.
