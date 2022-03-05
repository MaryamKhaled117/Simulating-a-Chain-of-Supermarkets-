%% M/M/C Model
clc;
clear;

lambda =5;     %arrival rate
mu = 20;       %service rate 

%User inputs number of customers
prompt = 'enter number of customers :';
customers=input(prompt);
%poisson random from 1 to no. of customers  
inter_arrival = poissrnd(lambda,1,customers);  
%time between arrivals using cumulative sum
customer_arrival = cumsum(inter_arrival);      
%first customer arrives in time =1
customer_arrival(1)=1;                        
%customer service time exponential from 1 to no.of customers
cus_service_time = exprnd(mu,1,customers);
%Probability distribution of the customers come on the store(arrive to the supermarket)
customer_arrival_supermarket = poissrnd(lambda,1,customers);
%Probability of customers needed to each pick items
no_of_items=40000;
Pick_items = exprnd(mu,1,no_of_items);

%%%%%%%%% distribusion of items and number of items of each type %%%%%%%%%
%divide each section into subsections through array
item_type = ["snacks", "fruits & vegies", "meet","dairy","bakery"];
snacks = ["chips","choclates","soft_drinks","biscuits"];
fruits_vegies = ["apple","banana","orange","tomatoes","pepper","carrots","onions"];
meat = ["chicken","fish","burger","sausage","shrimps"];
dairy =["milk","cheese","butter","yoghurt"];
bakery = ["bread","cake","toast"];

%using random sampling to output each customer will pick items from..
%..different sections and subsections randomly
n = randsample(bakery,customers,true);
disp("distribution of bakery")
disp(n)

n1 = randsample(dairy,customers,true);
disp("distribution of dairy")
disp(n1)

n2 = randsample(meat,customers,true);
disp("distribution of meat")
disp(n2)

n3 = randsample(snacks,customers,true);
disp("distribution of snacks")
disp(n3)

n4 = randsample(fruits_vegies,customers,true);
disp("distribution of fruits_vegies")
disp(n4)

%%Simulation
%create empty queue
queue = [];
customer = 0; %intialize no. of customers by 0 to start count in the loop
 
%Define variables for simulation
Cashiers = 4; 
Baggers = 4;
time = 0;  
%simulation time= arrival of last customer + time taken during service
sim_time = customer_arrival(end)+cus_service_time(end); 
time_sevice_ends=0;
  
while(time<=sim_time || ~isempty(queue) || Cashiers==0 || Baggers==0)
    time = time+1;
    if(ismember(time,customer_arrival)) %when time is equal arrival time of one of the customers 
        customer = customer +1;    %increment to enter the next customer
        queue = [queue customer];   
    end
    %There is an available server and the customers in the queue 
    if(Cashiers>0 && Baggers>0 && ~isempty(queue))
    %time service end= time arrival + time taken during service(cashier&bagging) 
         time_sevice_ends = time + cus_service_time(customer);
         time_sevice_ends = round(time_sevice_ends);
         queue = queue(:,1:end-1);   %get all rows and drop last colomn
         Cashiers=Cashiers-1;
         Baggers=Baggers-1;
    end
    
    if(time == time_sevice_ends) %if time is equal to the time the service ends
        Cashiers=Cashiers+1;           
        Baggers=Baggers+1;
    end
end


Avg_cust_arrival_time=0;
sum=0;

for i=inter_arrival
    sum = sum + i;
   
end

%%% Reduce number of cashiers in the non-peak hours %%%
%Output if its non-peak hrs or the num. of Cashiers & Baggers are suffcient
Avg_cust_arrival_time = round(sum/customers);

%if loop to display messages and output num. of employees 
if (Avg_cust_arrival_time < 20 && time<150)
    disp('It looks like that now is a non-peak hours you can decrease the number employees')
    Cashiers = round(4-Cashiers);
    Baggers = round(4-Baggers);
    fprintf("the number of cashiers needed is %d out of 4, and the number of baggers needed is %d out of 4\n", Cashiers,Baggers)
else
    disp('The number of employees is sufficient so the Cashiers =')
    disp (4)
    disp('And the number of Baggers =')
    disp (4)
    
end
fprintf('value of average customer arrival time is %d\n',Avg_cust_arrival_time)

time




%% Statistics 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C = 4;    %number of servers
%%The probability that there are zero people or units in the system
syms n
First_term= symsum(((1/factorial(n))*(lambda/mu)^n),n,0,C-1);
Second_term = ((1/factorial(C))*((lambda/mu)^C))*((C*mu)/(C*mu-lambda));
P0=1/(First_term+Second_term);
P0=round(P0,7);
disp('The probability that there are zero people or units in the system=')
disp(P0)

%The average number of units (Customers in the system) L
D=factorial(C-1)*(C*mu-lambda)^2;
N=lambda*mu*(lambda/mu)^C;
L=(N/D)*P0+(lambda/mu);
L=round(L,7);
disp('The average number of units (Customers in the system) L=')
disp(L)

%The average time a unit spends in the system 
W=L/lambda;
W=round(W,7);
disp('The average time a unit spends in the system =')
disp(W)

%The average number of units waiting in the Queue 
Lq= L-(lambda/mu);
Lq=round(Lq,7);
disp('average number of units waiting in the Queue  =')
disp(Lq)

%The average time a unit spends waiting in the Queue
Wq=Lq/lambda;
Wq=round(Wq,7);
disp('The average time a unit spends waiting in the Queue=')
disp(Wq)

%Utilization factor of the system
utilization_factor_for_the_system = lambda/(mu*C);
fprintf('utilization factor for the system is= %d\n',utilization_factor_for_the_system)