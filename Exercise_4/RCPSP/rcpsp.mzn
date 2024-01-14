include "globals.mzn";


int: n_tasks; % Number of tasks
set of int: tasks = 1..n_tasks;  
array[tasks] of int: duration; % Task durations

int: n_res;   % Number of resources
set of int: resources = 1..n_res; 
array[resources] of int: L; % Resource capacities
array[resources, tasks] of int: req; %Resource requirements of tasks

int: p;       % Number of precedence relations
set of int: prec = 1..p;
array[prec, 1..2] of tasks: pre; % Precedence relations


array[tasks] of var 0..sum(duration): START;

constraint forall(i in prec) (
  let { int: previous = pre[i, 1]; int: next = pre[i, 2]; } in
    START[previous] + duration[previous] <= START[next]
);

constraint forall(res in resources) (
  cumulative(START, duration, row(req, res), L[res])
); 

var int: makespan = max([START[i] + duration[i] | i in tasks]); 

%% DEFAULT SEARCH
solve minimize makespan;

%% EST SEARCH
%solve::int_search(START, smallest, indomain_min) minimize makespan;

output ["START \(START) \n", "makespan: \(makespan)"];


