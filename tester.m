%% First Case
clear;clc;
tic

St_Peak_Age_Array = cell(3);
Peak_Age_Array = cell(3);
numberOfPasses = [4 12 24]; %number of satellite passes
Days = 5; %simulation day duration
Nodes = [19 51 99];
queueLength = 25; %queue length
RelayNodeCapacity = 7; %relay node capacity
t = 0.1:0.1:Days*24*60*60;
for caseNum = 1:3
    satPassNum = numberOfPasses(caseNum); %selected sat pass case
    numOfNodes = Nodes(caseNum); %number of nodes

    StandardDumb_Relay;
    St_Peak_Age_Array{caseNum,1} = PeakAge_PerNode;
    St_Peak_Age_Array{caseNum,2} = numOfTx;
    St_Peak_Age_Array{caseNum,3} = numOfRelayTx;
    FreshData_Relay;
    Peak_Age_Array{caseNum,1} = PeakAge_PerNode;
    Peak_Age_Array{caseNum,2} = numOfTx;
    Peak_Age_Array{caseNum,3} = numOfRelayTx;

end
toc

%%
figure
subplot(3,2,1);
stem(1:length(Peak_Age_Array{1,1}),Peak_Age_Array{1,1}); 
hold on
stem(1:length(St_Peak_Age_Array{1,1}),St_Peak_Age_Array{1,1}); 
xlabel("Node Index");
ylabel("Peak Age");
grid on
legend(["Freshdata Relay", "Standard Relay"],"Location","northeast");
title(sprintf("%d Satellite Passes Per day for %d nodes",numberOfPasses(1),Nodes(1)));

subplot(3,2,2);
stem(1:length(Peak_Age_Array{1,2}),Peak_Age_Array{1,2}-Peak_Age_Array{1,3});
hold on
stem(1:length(St_Peak_Age_Array{1,2}),St_Peak_Age_Array{1,2}-St_Peak_Age_Array{1,3}); 
 
xlabel("Node Index");
ylabel("Number of Lost Packets");
grid on
legend(["Freshdata Relay", "Standard Relay"],"Location","northeast");
title(sprintf("%d Satellite Passes Per day for %d nodes",numberOfPasses(1),Nodes(1)));

subplot(3,2,3);
stem(1:length(Peak_Age_Array{2,1}),Peak_Age_Array{2,1}); 
hold on
stem(1:length(St_Peak_Age_Array{2,1}),St_Peak_Age_Array{2,1});
xlabel("Node Index");
ylabel("Peak Age");
grid on
legend(["Freshdata Relay", "Standard Relay"],"Location","northeast");
title(sprintf("%d Satellite Passes Per day for %d nodes",numberOfPasses(2),Nodes(2)));

subplot(3,2,4);
stem(1:length(Peak_Age_Array{2,1}),Peak_Age_Array{2,2}-Peak_Age_Array{2,3});
hold on
stem(1:length(St_Peak_Age_Array{2,1}),St_Peak_Age_Array{2,2}-St_Peak_Age_Array{2,3});
 
xlabel("Node Index");
ylabel("Number of Lost Packets");
grid on
legend(["Freshdata Relay", "Standard Relay"],"Location","northeast");
title(sprintf("%d Satellite Passes Per day for %d nodes",numberOfPasses(2),Nodes(2)));

subplot(3,2,5);
stem(1:length(Peak_Age_Array{3,1}),Peak_Age_Array{3,1}); 
hold on
stem(1:length(St_Peak_Age_Array{3,1}),St_Peak_Age_Array{3,1});

xlabel("Node Index");
ylabel("Peak Age");
grid on
legend(["Freshdata Relay", "Standard Relay"],"Location","northeast");
title(sprintf("%d Satellite Passes Per day for %d nodes",numberOfPasses(3),Nodes(3)));

subplot(3,2,6);
stem(1:length(Peak_Age_Array{3,1}),Peak_Age_Array{3,2}-Peak_Age_Array{3,3}); 
hold on
stem(1:length(St_Peak_Age_Array{3,1}),St_Peak_Age_Array{3,2}-St_Peak_Age_Array{3,3});

xlabel("Node Index");
ylabel("Number of Lost Packets");
grid on
legend(["Freshdata Relay", "Standard Relay"],"Location","northeast");
title(sprintf("%d Satellite Passes Per day for %d nodes",numberOfPasses(3),Nodes(3)));

