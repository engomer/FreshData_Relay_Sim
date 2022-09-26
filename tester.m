%% First Case
clear;clc;
tic
St_Mean_Age_Array = zeros(5,4);
Mean_Age_Array = zeros(5,4);
St_Peak_Age_Array = zeros(5,4);
Peak_Age_Array = zeros(5,4);
NodeNum = 10:10:100;
figure
for xx = 1:6
    numberOfPasses = [2 4 8 10 15 20]; %number of satellite passes
    satPassNum = numberOfPasses(xx); %selected sat pass case
    Days = 15; %simulation day duration
    %numOfNodes = 10; %number of nodes
    queueLength = 100; %queue length
    RelayNodeCapacity = 7; %relay node capacity
    t = 0.1:0.1:Days*24*60*60;
    for numOfNodes=10:10:100
        idx = numOfNodes/10;
        StandardDumb_Relay;
        St_Mean_Age_Array(idx,xx) = meanAge;
        St_Peak_Age_Array(idx,xx) = minmeanPeakAge_PerNode;
        FreshData_Relay;
        Mean_Age_Array(idx,xx) = meanAge;
        Peak_Age_Array(idx,xx) = minmeanPeakAge_PerNode;
    end
    subplot(3,2,xx);
    plot(NodeNum,St_Mean_Age_Array(:,xx), 'b--*'); 
    hold on
    plot(NodeNum,Mean_Age_Array(:,xx), 'g--*');
    xlabel("Number of Nodes");
    ylabel("AoI");
    grid on
    legend(["Standard Relay", "FreshData Relay"],"Location","east");
    title(sprintf("%d Satellite Passes Per day for %d days",satPassNum,Days));
end
toc

%%
figure
subplot(2,2,1);
plot(NodeNum,St_Peak_Age_Array(:,1), 'b--*'); 
hold on
plot(NodeNum,Peak_Age_Array(:,1), 'g--*');
xlabel("Number of Nodes");
ylabel("AoI");
grid on
legend(["Standard Relay", "FreshData Relay"],"Location","east");
title(sprintf("%d Satellite Passes Per day for %d days",2,3));

subplot(2,2,2);
plot(NodeNum,St_Peak_Age_Array(:,2), 'b--*'); 
hold on
plot(NodeNum,Peak_Age_Array(:,2), 'g--*');
xlabel("Number of Nodes");
ylabel("AoI");
grid on
legend(["Standard Relay", "FreshData Relay"],"Location","east");
title(sprintf("%d Satellite Passes Per day for %d days",4,3));

subplot(2,2,3);
plot(NodeNum,St_Peak_Age_Array(:,3), 'b--*'); 
hold on
plot(NodeNum,Peak_Age_Array(:,3), 'g--*');
xlabel("Number of Nodes");
ylabel("AoI");
grid on
legend(["Standard Relay", "FreshData Relay"],"Location","east");
title(sprintf("%d Satellite Passes Per day for %d days",10,3));

subplot(2,2,4);
plot(NodeNum,St_Peak_Age_Array(:,4), 'b--*'); 
hold on
plot(NodeNum,Peak_Age_Array(:,4), 'g--*');
xlabel("Number of Nodes");
ylabel("AoI");
grid on
legend(["Standard Relay", "FreshData Relay"],"Location","east");
title(sprintf("%d Satellite Passes Per day for %d days",15,3));

%% 
% figure
% subplot(2,2,1);
% plot(NodeNum,St_Mean_Age_Array(:,1), 'b--*'); 
% hold on
% plot(NodeNum,Mean_Age_Array(:,1), 'g--*');
% xlabel("Number of Nodes");
% ylabel("Peak Age");
% grid on
% legend(["Standard Relay", "FreshData Relay"],"Location","east");
% title(sprintf("%d Satellite Passes Per day for %d days",2,3));
% 
% subplot(2,2,2);
% plot(NodeNum,St_Mean_Age_Array(:,2), 'b--*'); 
% hold on
% plot(NodeNum,Mean_Age_Array(:,2), 'g--*');
% xlabel("Number of Nodes");
% ylabel("Peak Age");
% grid on
% legend(["Standard Relay", "FreshData Relay"],"Location","east");
% title(sprintf("%d Satellite Passes Per day for %d days",4,3));
% 
% subplot(2,2,3);
% plot(NodeNum,St_Mean_Age_Array(:,3), 'b--*'); 
% hold on
% plot(NodeNum,Mean_Age_Array(:,3), 'g--*');
% xlabel("Number of Nodes");
% ylabel("Peak Age");
% grid on
% legend(["Standard Relay", "FreshData Relay"],"Location","east");
% title(sprintf("%d Satellite Passes Per day for %d days",10,3));
% 
% subplot(2,2,4);
% plot(NodeNum,St_Mean_Age_Array(:,4), 'b--*'); 
% hold on
% plot(NodeNum,Mean_Age_Array(:,4), 'g--*');
% xlabel("Number of Nodes");
% ylabel("Peak Age");
% grid on
% legend(["Standard Relay", "FreshData Relay"],"Location","east");
% title(sprintf("%d Satellite Passes Per day for %d days",15,3));
