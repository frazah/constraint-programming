enum ITEM; %a set of items to pack
int: capacity; %knapsack capacity

array[ITEM] of int: profits; %item profits
array[ITEM] of int: weights; %item weights

array[ITEM] of var 0..1: knapsack; % a Bool. variable 
                                   % for each item
var int: totalProfit; %objective function  
 
constraint sum (i in ITEM) (weights[i]*knapsack[i]) <= capacity;
constraint totalProfit = sum (i in ITEM) (profits[i]*knapsack[i]);

solve maximize totalProfit;

output ["knapsack = \(knapsack)\n", "Total Profit = ", show(totalProfit)];