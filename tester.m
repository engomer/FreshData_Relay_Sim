%% First Case
clear;clc;
tic
St_Mean_Age_Array = zeros(10,4);
Mean_Age_Array = zeros(10,4);
for xx = 1:4
    numberOfPasses = [2 4 10 15]; %number of satellite passes
    satPassNum = numberOfPasses(xx); %selected sat pass case
    Days = 3; %simulation day duration
    %numOfNodes = 10; %number of nodes
    queueLength = 25; %queue length
    RelayNodeCapacity = 7; %relay node capacity
    t = 0.1:0.1:Days*24*60*60;
    for numOfNodes=10:10:100
        idx = numOfNodes/10;
        StandardDumb_Relay;
        St_Mean_Age_Array(idx,xx) = meanAge;
        FreshData_Relay;
        Mean_Age_Array(idx,xx) = meanAge;
    end
end
toc
subplot(2,2,1);
plot(10:10:100,St_Mean_Age_Array(:,1), 'b--*'); 
hold on
plot(10:10:100,Mean_Age_Array(:,1), 'g--*');
xlabel("Number of Nodes");
ylabel("AoI");
grid on
legend(["Standard Relay", "FreshData Relay"],"Location","east");
title(sprintf("%d Satellite Passes Per day for %d days",satPassNum,Days));

subplot(2,2,2);
plot(10:10:100,St_Mean_Age_Array(:,2), 'b--*'); 
hold on
plot(10:10:100,Mean_Age_Array(:,2), 'g--*');
xlabel("Number of Nodes");
ylabel("AoI");
grid on
legend(["Standard Relay", "FreshData Relay"],"Location","east");
title(sprintf("%d Satellite Passes Per day for %d days",satPassNum,Days));

subplot(2,2,3);
plot(10:10:100,St_Mean_Age_Array(:,3), 'b--*'); 
hold on
plot(10:10:100,Mean_Age_Array(:,3), 'g--*');
xlabel("Number of Nodes");
ylabel("AoI");
grid on
legend(["Standard Relay", "FreshData Relay"],"Location","east");
title(sprintf("%d Satellite Passes Per day for %d days",satPassNum,Days));

subplot(2,2,4);
plot(10:10:100,St_Mean_Age_Array(:,4), 'b--*'); 
hold on
plot(10:10:100,Mean_Age_Array(:,4), 'g--*');
xlabel("Number of Nodes");
ylabel("AoI");
grid on
legend(["Standard Relay", "FreshData Relay"],"Location","east");
title(sprintf("%d Satellite Passes Per day for %d days",satPassNum,Days));