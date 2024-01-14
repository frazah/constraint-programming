include "globals.mzn";

int: M;     %number of machines = number of tasks
int: J;     %number of jobs
set of int: MACH = 1..M;
set of int: TASK = 1..M; 
set of int: JOB = 1..J;
array[JOB,TASK] of MACH: machine;    % machines for tasks
array[JOB,MACH] of int: duration;     % task durations on machines
int: maxTime = sum(duration);

array[JOB, TASK] of var 0..maxTime: START;
var 0..maxTime: ENDTIME;

function 0..max(duration): duration(JOB: job, TASK: task) = 
  duration[job, machine[job, task]];


constraint forall(j in JOB, task in 1..M-1 ) (
    START[j, task] + duration(j, task) <= START[j, task + 1] 
);


constraint forall(j in JOB) (
  START[j, max(TASK)] + duration(j, max(TASK)) <= ENDTIME
);


constraint forall(m in MACH) (
    disjunctive(
      [ START[j, t] | j in JOB, t in TASK where machine[j, t] = m], 
      duration[.., m] 
  )
);

%solve :: int_search(START, smallest, indomain_min) minimize ENDTIME;
solve minimize ENDTIME;